package com.heoby.s3.service;


import com.heoby.global.common.entity.FileMetadata;
import com.heoby.global.common.enums.FileCategory;
import com.heoby.s3.repository.FileMetadataRepository;
import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.ServerSideEncryption;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;

@Service
@RequiredArgsConstructor
@Slf4j
public class S3ServiceImpl implements S3Service {

    private final S3Client s3Client;
    private final S3Presigner s3Presigner;
    private final FileMetadataRepository fileMetadataRepository;

    @Value("${s3.bucket}")
    private String bucket;

    @Value("${s3.presign.exp-min:5}")
    private long presignMinutes;

    // ====== Public APIs ======

    @Override
    public void uploadFile(MultipartFile file, FileCategory category, Long relatedId, Integer sequence) {
        if (file == null || file.isEmpty()) throw new IllegalArgumentException("파일이 비었습니다.");
        int seq = (sequence == null ? 0 : sequence);

        String key = buildKey(category, relatedId, seq, file.getOriginalFilename());
        putObjectStreaming(key, file);

        // DB 저장 (최소 스키마에 맞춤)
        FileMetadata meta = FileMetadata.builder()
            .fileCategory(category)
            .relatedId(relatedId)
            .fileName(file.getOriginalFilename())
            .sequence(seq)
            .fileExtension(getExt(file.getOriginalFilename()))
            .storageKey(key)
            .build();

        fileMetadataRepository.save(meta);
    }

    @Override
    public void updateFile(MultipartFile file, FileCategory category, Long relatedId, Integer sequence) {
        if (file == null || file.isEmpty()) throw new IllegalArgumentException("파일이 비었습니다.");
        int seq = (sequence == null ? 0 : sequence);

        // 1) 기존 파일 있으면 삭제 (DB & S3)
        fileMetadataRepository.findByFileCategoryAndRelatedIdAndSequence(category, relatedId, seq)
            .ifPresent(existing -> {
                safeDeleteFromS3(existing.getStorageKey());
                fileMetadataRepository.delete(existing);
            });

        // 2) 새 파일 업로드 + 저장
        uploadFile(file, category, relatedId, seq);
    }

    @Override
    public String getPresignedUrl(FileCategory category, Long relatedId, Integer sequence) {
        int seq = (sequence == null ? 0 : sequence);

        String key = fileMetadataRepository
            .findByFileCategoryAndRelatedIdAndSequence(category, relatedId, seq)
            .orElseThrow(() -> new IllegalStateException("파일이 없습니다."))
            .getStorageKey();

        return generatePresignedGetUrl(key);
    }

    @Override
    public void deleteFile(FileCategory category, Long relatedId, Integer sequence) {
        int seq = (sequence == null ? 0 : sequence);

        var meta = fileMetadataRepository
            .findByFileCategoryAndRelatedIdAndSequence(category, relatedId, seq)
            .orElseThrow(() -> new IllegalStateException("파일이 없습니다."));

        safeDeleteFromS3(meta.getStorageKey());
        fileMetadataRepository.delete(meta);
    }

    // ====== Internal helpers ======

    private String buildKey(FileCategory category, Long relatedId, int sequence, String originalName) {
        // 예) heoby/IMAGES/101/2025/11/03/1730612345123_0.jpg
        String ymd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        String ext = getExt(originalName);
        String base = (originalName == null ? "file" : originalName).replaceAll("\\s+", "_");
        long now = System.currentTimeMillis();
        return String.format("heoby/%s/%d/%s/%d_%d.%s",
            category.name(), relatedId, ymd, now, sequence, ext);
    }

    private String getExt(String filename) {
        if (filename == null) return "bin";
        int dot = filename.lastIndexOf('.');
        return (dot > -1 && dot < filename.length() - 1)
            ? filename.substring(dot + 1).toLowerCase()
            : "bin";
    }

    private void putObjectStreaming(String key, MultipartFile file) {
        try (InputStream in = file.getInputStream()) {
            PutObjectRequest req = PutObjectRequest.builder()
                .bucket(bucket)
                .key(key)
                .contentType(file.getContentType())
                .serverSideEncryption(ServerSideEncryption.AES256) // SSE-S3(선택)
                .build();

            s3Client.putObject(req, RequestBody.fromInputStream(in, file.getSize()));
            log.debug("S3 PutObject ok: s3://{}/{}", bucket, key);
        } catch (IOException e) {
            throw new RuntimeException("로컬 파일 읽기 실패", e);
        } catch (Exception e) {
            throw new RuntimeException("S3 업로드 실패", e);
        }
    }

    private String generatePresignedGetUrl(String key) {
        var get = GetObjectRequest.builder()
            .bucket(bucket)
            .key(key)
            .build();

        var presign = GetObjectPresignRequest.builder()
            .signatureDuration(Duration.ofMinutes(presignMinutes))
            .getObjectRequest(get)
            .build();

        String url = s3Presigner.presignGetObject(presign).url().toString();
        log.debug("Presigned GET: {}", url);
        return url;
    }

    private void safeDeleteFromS3(String key) {
        try {
            s3Client.deleteObject(DeleteObjectRequest.builder()
                .bucket(bucket)
                .key(key)
                .build());
            log.debug("S3 Delete ok: s3://{}/{}", bucket, key);
        } catch (Exception e) {
            // 정책에 따라 무시할 수도 있음. 여기서는 예외를 던져 상위에서 알 수 있게 함.
            throw new RuntimeException("S3 삭제 실패", e);
        }
    }


}

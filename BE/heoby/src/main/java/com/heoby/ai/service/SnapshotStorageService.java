package com.heoby.ai.service;

import com.heoby.ai.util.Base64ImageMultipartFile;
import com.heoby.global.common.entity.Detection;
import com.heoby.global.common.enums.FileCategory;
import com.heoby.s3.service.S3Service;
import java.nio.file.Files;
import java.nio.file.Path;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;

@Service
@RequiredArgsConstructor
public class SnapshotStorageService {

  private final S3Service s3Service;

  public String storeDetectionSnapshot(Detection detection, String base64Image) {
    if (detection == null || base64Image == null || base64Image.isBlank()) {
      return null;
    }

    String cleaned = cleanBase64(base64Image);
    byte[] bytes = Base64.getDecoder().decode(cleaned);

    // 디버그: EC2에 로컬 파일로 한 번 저장해보기
    try {
      Files.write(Path.of("/tmp/heoby-debug.jpg"), bytes);
      System.out.println("[SNAPSHOT-DEBUG] wrote /tmp/heoby-debug.jpg, size=" + bytes.length);
    } catch (Exception e) {
      e.printStackTrace();
    }

    Long relatedId = detection.getDetectionId();
    int sequence = 0;

    String fileName = "detection-" + relatedId + ".jpg";

    MultipartFile file = new Base64ImageMultipartFile(
        bytes,
        "snapshot",
        fileName,
        "image/jpeg"
    );

    s3Service.uploadFile(file, FileCategory.IMAGES, relatedId, sequence);
    String url = s3Service.getPresignedUrl(FileCategory.IMAGES, relatedId, sequence);

    detection.setSnapshotUrl(url);
    return url;
  }

  private String cleanBase64(String raw) {
    int comma = raw.indexOf(',');
    return (comma > 0) ? raw.substring(comma + 1) : raw.trim();
  }
}

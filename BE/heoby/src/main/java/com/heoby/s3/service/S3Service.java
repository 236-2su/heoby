package com.heoby.s3.service;

import com.heoby.global.common.enums.FileCategory;
import org.springframework.web.multipart.MultipartFile;

public interface S3Service {

    // 업로드(신규)
    void uploadFile(MultipartFile file, FileCategory category, Long relatedId, Integer sequence);

    // 교체(있으면 삭제 후, 새로 업로드)
    void updateFile(MultipartFile file, FileCategory category, Long relatedId, Integer sequence);

    // presigned GET URL 발급
    String getPresignedUrl(FileCategory category, Long relatedId, Integer sequence);

    // 삭제
    void deleteFile(FileCategory category, Long relatedId, Integer sequence);


}

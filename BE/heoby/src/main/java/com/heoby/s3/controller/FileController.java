package com.heoby.s3.controller;

import com.heoby.global.common.enums.FileCategory;
import com.heoby.s3.service.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/files")
public class FileController {

    private final S3Service s3Service;

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> upload(
        @RequestPart("file") MultipartFile file,
        @RequestParam FileCategory category,
        @RequestParam Long relatedId,
        @RequestParam(defaultValue = "0") Integer sequence) {
        s3Service.uploadFile(file, category, relatedId, sequence);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @GetMapping("/presign")
    public ResponseEntity<String> presign(
        @RequestParam FileCategory category,
        @RequestParam Long relatedId,
        @RequestParam(defaultValue = "0") Integer sequence) {
        return ResponseEntity.ok(s3Service.getPresignedUrl(category, relatedId, sequence));
    }

    @DeleteMapping
    public ResponseEntity<Void> delete(
        @RequestParam FileCategory category,
        @RequestParam Long relatedId,
        @RequestParam(defaultValue = "0") Integer sequence) {
        s3Service.deleteFile(category, relatedId, sequence);
        return ResponseEntity.noContent().build();
    }

    @PutMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> update(
        @RequestPart("file") MultipartFile file,
        @RequestParam FileCategory category,
        @RequestParam Long relatedId,
        @RequestParam(defaultValue = "0") Integer sequence) {
        s3Service.updateFile(file, category, relatedId, sequence);
        return ResponseEntity.ok().build();
    }

}

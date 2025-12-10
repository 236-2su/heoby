package com.heoby.s3.repository;

import com.heoby.global.common.entity.FileMetadata;
import com.heoby.global.common.enums.FileCategory;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {

    Optional<FileMetadata> findByFileCategoryAndRelatedIdAndSequence(
        FileCategory fileCategory, Long relatedId, Integer sequence);

    Optional<FileMetadata> findByStorageKey(String storageKey);

}

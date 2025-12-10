package com.heoby.global.common.entity;


import com.heoby.global.common.enums.FileCategory;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "file_metadata",
    uniqueConstraints = @UniqueConstraint(name = "uq_storage_key", columnNames = "storage_key"),
    indexes = {
        @Index(name = "idx_rel", columnList = "file_category, related_id, sequence")
    })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FileMetadata {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "file_id")
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "file_category", nullable = false, length = 20)
    private FileCategory fileCategory;

    @Column(name = "related_id", nullable = false)
    private Long relatedId;

    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    @Column(name = "sequence", nullable = false)
    private Integer sequence;

    @Column(name = "file_extension", nullable = false, length = 20)
    private String fileExtension;

    @Column(name = "storage_key", nullable = false, length = 512)
    private String storageKey;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (sequence == null) sequence = 0;
    }

}

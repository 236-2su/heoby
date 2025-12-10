package com.heoby.global.common.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(
    name = "device_token",
    uniqueConstraints = @UniqueConstraint(name = "uk_token", columnNames = "token"),
    indexes = {
        @Index(name = "idx_user_uuid", columnList = "user_uuid"),
        @Index(name = "idx_platform", columnList = "platform")
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DeviceToken {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name = "user_uuid", length = 50, nullable = false)
  private String userUuid;

  @Column(name = "platform", length = 16, nullable = false)
  private String platform; // ANDROID, IOS, WEB, WEAR_OS

  @Column(name = "token", length = 512, nullable = false)
  private String token;

  @Column(name = "enabled", nullable = false)
  private Boolean enabled;

  @Column(name = "last_seen_at")
  private LocalDateTime lastSeenAt;

  @CreationTimestamp
  @Column(name = "created_at", updatable = false, nullable = false)
  private LocalDateTime createdAt;

  @UpdateTimestamp
  @Column(name = "updated_at", nullable = false)
  private LocalDateTime updatedAt;
}

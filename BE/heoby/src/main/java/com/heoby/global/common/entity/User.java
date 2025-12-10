package com.heoby.global.common.entity;

import com.heoby.global.common.enums.Role;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "User")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "user_uuid", length = 36, nullable = false, unique = true)
    private String userUuid; // UUID (직접 생성 or @GeneratedValue(strategy = UUID)도 가능)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_village_id", insertable = false, updatable = false)
    private Village village; // 소속 마을 (nullable)

    @Column(name = "user_village_id")
    private Long userVillageId; // 소속 마을 ID (nullable)

    @Column(name = "username", length = 16, nullable = false)
    private String username;

    @Column(name = "email", length = 255, nullable = false, unique = true)
    private String email;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", length = 10, nullable = false)
    @Builder.Default
    private Role role = Role.USER;

    @Column(name = "kakao_user_id", length = 255, nullable = false)
    private String kakaoUserId;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

}

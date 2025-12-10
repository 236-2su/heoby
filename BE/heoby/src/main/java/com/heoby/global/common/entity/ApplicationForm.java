package com.heoby.global.common.entity;

import com.heoby.global.common.enums.ApplicationStatus;
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

@Entity
@Table(name = "ApplicationForm")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApplicationForm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long formId;

    @Column(name = "user_uuid", length = 36, nullable = false, unique = true)
    private String userUuid;

    @Column(name = "village_id")
    private Long villageId;

    @Column(name = "cert_url")
    private String certUrl;

    @Enumerated(EnumType.STRING)
    private ApplicationStatus registrationStatus;

    private String content;
    private String refuseContent;

    private LocalDateTime createdAt;

}

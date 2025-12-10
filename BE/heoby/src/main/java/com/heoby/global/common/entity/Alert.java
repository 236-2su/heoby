package com.heoby.global.common.entity;

import com.heoby.global.common.enums.AlertSeverity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
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
@Table(name = "Alert")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Alert {

    @Id
    @Column(name = "alert_uuid", length = 36)
    private String alertUuid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_uuid")
    private User sender;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_uuid")
    private User receiver;

    @Column(name = "crow_uuid", length = 36)
    private String crowUuid;

    @Column(name = "detection_id")
    private Long detectionId;

    @Enumerated(EnumType.STRING)
    @Column(name = "severity", length = 10, nullable = false)
    private AlertSeverity severity; // CRITICAL/WARNING/INFO

    @Column(name = "message", length = 500, nullable = false)
    private String message;

    private LocalDateTime createdAt;

    @Column(name = "is_read")
    private Boolean isRead;

}

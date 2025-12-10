package com.heoby.global.common.entity;

import com.heoby.global.common.enums.ComponentStatus;
import com.heoby.global.common.enums.ConnectionStatus;
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
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "Scarecrow")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Scarecrow {

    @Id
    @Column(name = "crow_uuid", length = 36)
    private String crowUuid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_uuid")
    private User user;

    @Column(name = "serial_number", length = 8, nullable = false)
    private String serialNumber;

    @Column(name = "crow_name", length = 16, nullable = false)
    private String crowName;

    @Column(name = "village_id")
    private Long villageId;

    @Enumerated(EnumType.STRING)
    private ConnectionStatus connectionStatus;

    @Enumerated(EnumType.STRING)
    private ComponentStatus cameraStatus;

    @Enumerated(EnumType.STRING)
    private ComponentStatus thermalSensorStatus;

    @Enumerated(EnumType.STRING)
    private ComponentStatus thermohygrometerSensorStatus;

    @Enumerated(EnumType.STRING)
    private ComponentStatus speakerStatus;

    @Enumerated(EnumType.STRING)
    private ComponentStatus lightStatus;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

}

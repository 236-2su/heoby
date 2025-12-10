package com.heoby.global.common.entity;

import com.heoby.global.common.enums.VillageRegistrationStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "VillageRegistration")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VillageRegistration {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long registerId;

    @Column(name = "crow_uuid", length = 36)
    private String crowUuid;

    @Column(name = "village_id")
    private Long villageId;

    @Enumerated(EnumType.STRING)
    private VillageRegistrationStatus registrationStatus;

    private String registerContent;
    private String refuseContent;
    private LocalDateTime createdAt;
}

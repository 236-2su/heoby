package com.heoby.global.common.entity;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "Village")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Village {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "village_id")
    private Long villageId;

    @Column(name = "village_name", length = 16, nullable = false)
    private String villageName;

    @Column(name = "region_code", length = 32)
    private String regionCode;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

}

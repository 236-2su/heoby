package com.heoby.scarecrow.repository;

import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.enums.ComponentStatus;
import java.time.LocalDateTime;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface ScarecrowRepository extends JpaRepository<Scarecrow, String> {

    List<Scarecrow> findByUser_UserUuid(String userUuid);

    @Query("""
        SELECT s
        FROM Scarecrow s
        WHERE s.user.userUuid = :userUuid
        ORDER BY s.createdAt DESC
        """)
    List<Scarecrow> findMyScarecrows(@Param("userUuid") String userUuid);

    @Query("""
        SELECT s
        FROM Scarecrow s
        WHERE s.villageId = :villageId
        ORDER BY s.createdAt DESC
        """)
    List<Scarecrow> findVillageScarecrows(@Param("villageId") Long villageId);

    List<Scarecrow> findByCrowUuidIn(List<String> crowUuids);

    // LeaderDashboardService에서 사용할 메서드
    List<Scarecrow> findByUser_UserUuidIn(List<String> userUuids);

    Optional<Scarecrow> findBySerialNumber(String serialNumber);

    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
    update Scarecrow s
    set s.thermohygrometerSensorStatus = :disconnected
    where s.thermohygrometerSensorStatus <> :disconnected
      and s.updatedAt < :threshold
""")
    int markThermoHygrometerOfflineBefore(
        @Param("threshold") LocalDateTime threshold,
        @Param("disconnected") ComponentStatus disconnected
    );
}
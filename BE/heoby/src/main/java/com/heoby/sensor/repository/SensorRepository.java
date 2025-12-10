package com.heoby.sensor.repository;

import com.heoby.global.common.entity.Scarecrow;
import com.heoby.global.common.entity.Sensor;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SensorRepository extends JpaRepository<Sensor, Long> {

  Optional<Sensor> findByScarecrow_CrowUuid(String crowUuid);
  List<Sensor> findByScarecrow_CrowUuidIn(List<String> crowUuids);
  Optional<Sensor> findTopByScarecrowOrderByUpdatedAtDesc(Scarecrow scarecrow);

  @Query("""
        SELECT COALESCE(SUM(s.worker), 0)
        FROM Sensor s
        WHERE s.scarecrow.user.userUuid = :userUuid
        """)
  int sumWorkerByUserUuid(@Param("userUuid") String userUuid);

  @Query("""
      SELECT COALESCE(SUM(s.worker), 0)
      FROM Sensor s
      WHERE s.scarecrow.villageId = :villageId
      """)
  int sumWorkerByVillageId(@Param("villageId") Long villageId);
}

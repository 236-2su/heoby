package com.heoby.alert.repository;

import com.heoby.global.common.entity.Alert;
import com.heoby.global.common.enums.AlertSeverity;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AlertRepository extends JpaRepository<Alert, String> {

  @Query("""
    SELECT a
    FROM Alert a
    WHERE a.receiver.userUuid = :receiverUuid
    ORDER BY a.createdAt DESC
  """)
  List<Alert> findAllByReceiverOrderByCreatedDesc(@Param("receiverUuid") String receiverUuid);

  @Query("""
    SELECT COUNT(a)
    FROM Alert a
    WHERE a.receiver.userUuid = :receiverUuid AND a.isRead = false
  """)
  long countUnread(@Param("receiverUuid") String receiverUuid);

  @Query("""
    SELECT COUNT(a)
    FROM Alert a
    WHERE a.receiver.userUuid = :receiverUuid AND a.isRead = false AND a.severity = :severity
  """)
  long countUnreadBySeverity(@Param("receiverUuid") String receiverUuid,
      @Param("severity") AlertSeverity severity);

  // LeaderDashboardService에서 사용할 메서드
  @Query("""
    SELECT a
    FROM Alert a
    WHERE a.receiver.userUuid IN :receiverUuids
    ORDER BY a.createdAt DESC
  """)
  List<Alert> findAllByReceiverInOrderByCreatedDesc(@Param("receiverUuids") List<String> receiverUuids);

  @Query("""
    SELECT COUNT(a)
    FROM Alert a
    WHERE a.receiver.userUuid IN :receiverUuids AND a.isRead = false
  """)
  long countUnreadByReceiverIn(@Param("receiverUuids") List<String> receiverUuids);

  @Query("""
    SELECT COUNT(a)
    FROM Alert a
    WHERE a.receiver.userUuid IN :receiverUuids AND a.isRead = false AND a.severity = :severity
  """)
  long countUnreadByReceiverInAndSeverity(@Param("receiverUuids") List<String> receiverUuids,
      @Param("severity") AlertSeverity severity);
}

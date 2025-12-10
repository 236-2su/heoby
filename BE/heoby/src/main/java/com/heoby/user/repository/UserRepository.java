package com.heoby.user.repository;

import com.heoby.global.common.entity.User;
import com.heoby.global.common.enums.Role;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);

    Optional<User> findByUserUuid(String userUuid);

    List<User> findByUserVillageId(Long userVillageId);

    @Query("""
      SELECT u
      FROM User u
      WHERE u.role = :role
        AND u.userVillageId = (
          SELECT me.userVillageId
          FROM User me
          WHERE me.userUuid = :userUuid
        )
      """)
    Optional<User> findLeaderInSameVillageAs(
        @Param("userUuid") String userUuid,
        @Param("role") Role role
    );
    Optional<User> findFirstByRole(Role role);
}
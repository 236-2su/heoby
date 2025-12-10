package com.heoby.auth.dto.response;

import com.heoby.global.common.entity.User;
import com.heoby.global.common.enums.Role;
import java.time.LocalDateTime;

public record UserDto(
    String userUuid,
    String email,
    String username,
    Role role,
    Long villageId,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {
    public static UserDto from(User u) {
        return new UserDto(
            u.getUserUuid(),
            u.getEmail(),
            u.getUsername(),
            u.getRole(),
            u.getUserVillageId(),
            u.getCreatedAt(),
            u.getUpdatedAt()
        );
    }

}

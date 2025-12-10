package com.heoby.user.dto.response;

import com.heoby.global.common.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private String userUuid;
    private Long userVillageId;
    private String username;
    private String email;
    private Role role;
}

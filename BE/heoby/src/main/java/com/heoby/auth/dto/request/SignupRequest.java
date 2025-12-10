package com.heoby.auth.dto.request;

import com.heoby.global.common.enums.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record SignupRequest(
    @Email @NotBlank String email,
    @Size(min = 8, max = 50) String password,
    @NotBlank String username,
    @NotNull(message = "역할은 필수입니다.") Role role,        // "USER" | "LEADER" | "ADMIN"
    @Positive Long villageId // null 허용(미지정), 1 이상

) {}
package com.heoby.user.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserUpdateRequest {
    private Long userVillageId;

    @Size(max = 16, message = "이름은 최대 16자까지 가능합니다.")
    private String username;
}

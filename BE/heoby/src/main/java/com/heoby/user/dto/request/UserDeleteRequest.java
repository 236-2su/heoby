package com.heoby.user.dto.request;

import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserDeleteRequest {

    @Size(min = 8, message = "비밀번호는 8자 이상이어야 합니다.")
    private String password;       // 카카오 계정은 null 허용

    private String refreshToken;   // 현재 세션 RT (있으면 무효화 및 USED 처리)
}

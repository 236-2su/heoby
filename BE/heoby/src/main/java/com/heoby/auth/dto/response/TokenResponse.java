package com.heoby.auth.dto.response;

public record TokenResponse(
    String accessToken, long accessTokenExpiresIn,
    String refreshToken, long refreshTokenExpiresIn,
    String userUuid
) {

}

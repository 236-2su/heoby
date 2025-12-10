package com.heoby.auth.dto.response;

public record LoginResponse(
    String accessToken, long accessTokenExpiresIn,
    String refreshToken, long refreshTokenExpiresIn,
    UserDto user
) {

}

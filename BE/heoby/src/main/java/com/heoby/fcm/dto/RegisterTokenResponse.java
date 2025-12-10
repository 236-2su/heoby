package com.heoby.fcm.dto;

public record RegisterTokenResponse(
    String message,
    String token
) {}
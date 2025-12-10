package com.heoby.fcm.dto;

public record SingleFcmResponse(
    String message,
    int requestedCount
) {}

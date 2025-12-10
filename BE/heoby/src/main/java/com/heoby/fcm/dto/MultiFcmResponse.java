package com.heoby.fcm.dto;

public record MultiFcmResponse(
    String message,
    int requested,
    int success,
    int failure,
    int disabled,
    int retried
) {}
package com.heoby.ai.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record AiEventRequest(
    @NotBlank String event_id,
    @NotBlank String category,
    @NotBlank String stream_id,
    @NotNull Integer track_id,
    @NotBlank String timestamp_utc,
    int[] bbox,
    Double confidence,
    String pose_label,
    Double pose_confidence,
    Integer duration_seconds,
    List<List<Double>> keypoints,
    String species,
    Double species_confidence,
    String image_jpeg_base64,
    Integer inference_latency_ms
) {}

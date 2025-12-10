package com.heoby.ai.controller;

import com.heoby.ai.dto.AiEventRequest;
import com.heoby.ai.service.AiIngestService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class AiIngestController {

  private final AiIngestService service;

  @PostMapping("/events")
  public ResponseEntity<?> ingest(@RequestBody @Valid AiEventRequest req) {
    return ResponseEntity.ok(service.handleEvent(req));
  }
}

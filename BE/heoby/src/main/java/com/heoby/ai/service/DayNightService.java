package com.heoby.ai.service;

import org.springframework.stereotype.Service;

import java.time.*;
import java.time.format.DateTimeFormatter;

@Service
public class DayNightService {

  public boolean isDaytime(String utcIso) {
    LocalDateTime utc = LocalDateTime.parse(utcIso, DateTimeFormatter.ISO_DATE_TIME);
    LocalTime kst = utc.atOffset(ZoneOffset.UTC)
        .atZoneSameInstant(ZoneId.of("Asia/Seoul"))
        .toLocalTime();
    return !kst.isBefore(LocalTime.of(6, 0)) && kst.isBefore(LocalTime.of(14, 0));
  }
}

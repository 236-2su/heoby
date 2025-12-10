package com.sunshinemoongit.heoby.heoby_android.presentation.ui

import java.time.Instant
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.ZoneId

/**
 * 타임스탬프를 "HH:mm" 형식의 문자열로 변환합니다.
 *
 * @param timestamp Epoch 밀리초 단위의 타임스탬프입니다.
 * @return 형식화된 시간 문자열 또는 타임스탬프가 유효하지 않은 경우 빈 문자열입니다.
 */
fun formatTimestamp(timestamp: Long): String {
    if (timestamp <= 0L) return ""
    val instant = Instant.ofEpochMilli(timestamp)
    val localTime = LocalTime.ofInstant(instant, ZoneId.systemDefault())
    return "%02d:%02d".format(localTime.hour, localTime.minute)
}

/**
 * 측정 타임스탬프를 "마지막 측정: yyyy.MM.dd HH:mm" 형식의 문자열로 변환합니다.
 *
 * @param timestamp Epoch 밀리초 단위의 타임스탬프입니다.
 * @return 형식화된 측정 시간 문자열 또는 기록이 없는 경우 "마지막 측정: 기록 없음"입니다.
 */
fun formatMeasurementTimestamp(timestamp: Long): String {
    if (timestamp <= 0L) return "마지막 측정: 기록 없음"
    val instant = Instant.ofEpochMilli(timestamp)
    val localDateTime = LocalDateTime.ofInstant(instant, ZoneId.systemDefault())
    return "마지막 측정: %04d.%02d.%02d %02d:%02d".format(
        localDateTime.year,
        localDateTime.monthValue,
        localDateTime.dayOfMonth,
        localDateTime.hour,
        localDateTime.minute
    )
}

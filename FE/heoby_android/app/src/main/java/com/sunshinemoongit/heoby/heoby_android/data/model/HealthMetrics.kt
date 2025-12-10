package com.sunshinemoongit.heoby.heoby_android.data.model

/**
 * 건강 관련 지표를 나타내는 데이터 클래스입니다.
 *
 * @property heartRateBpm 분당 심박수 (BPM).
 * @property stepsSinceBoot 부팅 이후의 걸음 수.
 * @property lastUpdatedEpochMillis 마지막 업데이트 시간 (Epoch 밀리초).
 */
data class HealthMetrics(
    val heartRateBpm: Int?,
    val stepsSinceBoot: Int?,
    val lastUpdatedEpochMillis: Long
)


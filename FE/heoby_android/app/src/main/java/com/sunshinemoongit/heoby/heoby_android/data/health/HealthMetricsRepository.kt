package com.sunshinemoongit.heoby.heoby_android.data.health

import com.sunshinemoongit.heoby.heoby_android.data.model.HealthMetrics
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * 건강 지표 데이터를 관리하는 싱글톤 객체입니다.
 */
object HealthMetricsRepository {
    // 건강 지표를 저장하는 StateFlow
    private val _metrics = MutableStateFlow(
        HealthMetrics(
            heartRateBpm = null,
            stepsSinceBoot = null,
            lastUpdatedEpochMillis = 0L
        )
    )

    val metrics: StateFlow<HealthMetrics> = _metrics.asStateFlow()

    /**
     * 건강 지표를 업데이트합니다.
     *
     * @param metrics 새로운 건강 지표 데이터입니다.
     */
    fun update(metrics: HealthMetrics) {
        _metrics.value = metrics
    }
}


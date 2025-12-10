package com.sunshinemoongit.heoby.heoby_android.data.health

import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureAlert
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureReading
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

/**
 * 혈압 데이터와 알림을 관리하는 싱글톤 객체입니다.
 */
object BloodPressureRepository {
    private const val MAX_ALERT_HISTORY = 6

    // 최근 혈압 측정값을 저장하는 StateFlow
    private val _latestReading = MutableStateFlow<BloodPressureReading?>(null)
    val latestReading: StateFlow<BloodPressureReading?> = _latestReading.asStateFlow()

    // 혈압 관련 알림 목록을 저장하는 StateFlow
    private val _alerts = MutableStateFlow<List<BloodPressureAlert>>(emptyList())
    val alerts: StateFlow<List<BloodPressureAlert>> = _alerts.asStateFlow()

    /**
     * 최근 혈압 측정값을 업데이트합니다.
     *
     * @param reading 새로운 혈압 측정값입니다.
     */
    fun updateReading(reading: BloodPressureReading) {
        _latestReading.value = reading
    }

    /**
     * 혈압 관련 알림을 추가하거나 업데이트합니다. 알림 목록의 최대 크기는 `MAX_ALERT_HISTORY`로 제한됩니다.
     *
     * @param alert 추가하거나 업데이트할 혈압 알림입니다.
     */
    fun upsertAlert(alert: BloodPressureAlert) {
        _alerts.update { current ->
            val idx = current.indexOfFirst { it.id == alert.id }
            val updated = if (idx >= 0) {
                current.toMutableList().apply { this[idx] = alert }
            } else {
                (listOf(alert) + current).take(MAX_ALERT_HISTORY)
            }
            updated
        }
    }
}

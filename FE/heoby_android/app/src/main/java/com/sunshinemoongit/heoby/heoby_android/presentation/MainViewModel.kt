package com.sunshinemoongit.heoby.heoby_android.presentation

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.sunshinemoongit.heoby.heoby_android.data.health.BloodPressureAlertManager
import com.sunshinemoongit.heoby.heoby_android.data.health.BloodPressureRepository
import com.sunshinemoongit.heoby.heoby_android.data.health.HealthDataCollector
import com.sunshinemoongit.heoby.heoby_android.data.health.HealthMetricsRepository
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureReading
import com.sunshinemoongit.heoby.heoby_android.data.notifications.NotificationRepository
import com.sunshinemoongit.heoby.heoby_android.data.phone.PhoneSyncManager
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

/**
 * 메인 화면의 UI 상태를 관리하는 뷰모델입니다.
 *
 * @param application 애플리케이션 컨텍스트입니다.
 */
class MainViewModel(application: Application) : AndroidViewModel(application) {

    private val phoneSyncManager = PhoneSyncManager(application, viewModelScope)
    private val healthDataCollector =
        HealthDataCollector(application, phoneSyncManager, viewModelScope)
    private val bloodPressureAlertManager =
        BloodPressureAlertManager(phoneSyncManager, viewModelScope)

    val notifications = NotificationRepository.notifications
    val healthMetrics = HealthMetricsRepository.metrics
    val connectionState = phoneSyncManager.connectionState
    val bloodPressureReading = BloodPressureRepository.latestReading
    val bloodPressureAlerts = BloodPressureRepository.alerts

    private val _sensorsActive = MutableStateFlow(false)
    val sensorsActive: StateFlow<Boolean> = _sensorsActive.asStateFlow()
    private val _autoSyncEnabled = MutableStateFlow(true)
    val autoSyncEnabled: StateFlow<Boolean> = _autoSyncEnabled.asStateFlow()

    init {
        phoneSyncManager.start()
        viewModelScope.launch {
            phoneSyncManager.connectionState.collect { state ->
                if (state == PhoneSyncManager.ConnectionState.Connected) {
                    bloodPressureAlertManager.flushPending()
                }
            }
        }
    }

    /**
     * 센서 권한 요청 결과에 따라 데이터 수집을 시작하거나 중지합니다.
     *
     * @param granted 권한 부여 여부입니다.
     */
    fun onSensorsPermissionResult(granted: Boolean) {
        if (granted) {
            healthDataCollector.start()
            _sensorsActive.value = true
        } else {
            healthDataCollector.stop()
            _sensorsActive.value = false
        }
    }

    /**
     * 뷰모델이 소멸될 때 호출됩니다. 데이터 수집 및 동기화를 중지합니다.
     */
    override fun onCleared() {
        super.onCleared()
        healthDataCollector.stop()
        phoneSyncManager.stop()
    }

    /**
     * 수동으로 혈압을 기록하고, 필요한 경우 알림을 생성합니다.
     *
     * @param systolic 수축기 혈압입니다.
     * @param diastolic 이완기 혈압입니다.
     */
    fun recordBloodPressure(systolic: Int, diastolic: Int) {
        val reading = BloodPressureReading(
            systolic = systolic,
            diastolic = diastolic,
            timestamp = System.currentTimeMillis(),
            source = BloodPressureReading.Source.ManualDebug
        )
        bloodPressureAlertManager.submitReading(reading)
    }

    /**
     * 자동 동기화 설정을 토글합니다.
     */
    fun toggleAutoSync() {
        val newValue = !_autoSyncEnabled.value
        _autoSyncEnabled.value = newValue
        bloodPressureAlertManager.setAutoSyncEnabled(newValue)
    }
}


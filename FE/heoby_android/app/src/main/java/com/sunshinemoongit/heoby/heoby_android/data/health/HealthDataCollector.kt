package com.sunshinemoongit.heoby.heoby_android.data.health

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import com.sunshinemoongit.heoby.heoby_android.data.model.HealthMetrics
import com.sunshinemoongit.heoby.heoby_android.data.phone.PhoneSyncManager

/**
 * 센서로부터 건강 데이터를 수집하는 클래스입니다.
 *
 * @param context 애플리케이션 컨텍스트입니다.
 * @param phoneSyncManager 폰과 데이터 동기화를 관리하는 매니저입니다.
 * @param scope 코루틴 스코프입니다.
 */
class HealthDataCollector(
    private val context: Context,
    private val phoneSyncManager: PhoneSyncManager,
    private val scope: CoroutineScope
) : SensorEventListener {

    private val sensorManager: SensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val heartRateSensor: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE)
    private val stepCounterSensor: Sensor? =
        sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

    private var baseStepValue: Float? = null
    private var isCollecting = false

    /**
     * 센서 데이터 수집을 시작합니다.
     */
    fun start() {
        if (isCollecting) return
        isCollecting = true

        heartRateSensor?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }

        stepCounterSensor?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    /**
     * 센서 데이터 수집을 중지합니다.
     */
    fun stop() {
        if (!isCollecting) return
        sensorManager.unregisterListener(this)
        isCollecting = false
    }

    /**
     * 센서 데이터가 변경될 때 호출됩니다.
     *
     * @param event 센서 이벤트 객체입니다.
     */
    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        val timestamp = System.currentTimeMillis()

        when (event.sensor.type) {
            Sensor.TYPE_HEART_RATE -> {
                val bpm = event.values.firstOrNull()?.toInt()
                val currentMetrics = HealthMetricsRepository.metrics.value
                val updated = currentMetrics.copy(
                    heartRateBpm = bpm,
                    lastUpdatedEpochMillis = timestamp
                )
                dispatchMetrics(updated)
            }

            Sensor.TYPE_STEP_COUNTER -> {
                if (baseStepValue == null) {
                    baseStepValue = event.values.firstOrNull()
                }
                val steps = event.values.firstOrNull()?.let { value ->
                    val base = baseStepValue ?: value
                    (value - base).toInt().coerceAtLeast(0)
                }

                val currentMetrics = HealthMetricsRepository.metrics.value
                val updated = currentMetrics.copy(
                    stepsSinceBoot = steps,
                    lastUpdatedEpochMillis = timestamp
                )
                dispatchMetrics(updated)
            }
        }
    }

    /**
     * 센서의 정확도가 변경될 때 호출됩니다. (현재는 사용하지 않음)
     *
     * @param sensor 센서 객체입니다.
     * @param accuracy 새로운 정확도 값입니다.
     */
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // no-op
    }

    /**
     * 수집된 건강 데이터를 `HealthMetricsRepository`에 업데이트하고, 폰으로 전송합니다.
     *
     * @param metrics 업데이트할 건강 데이터입니다.
     */
    private fun dispatchMetrics(metrics: HealthMetrics) {
        HealthMetricsRepository.update(metrics)
        scope.launch(Dispatchers.Default) {
            phoneSyncManager.sendHealthMetrics(metrics)
        }
    }
}


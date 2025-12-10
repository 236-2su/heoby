package com.sunshinemoongit.heoby.heoby_android.data.health

import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureAlert
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureAlertSeverity
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureReading
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureThresholds
import com.sunshinemoongit.heoby.heoby_android.data.phone.PhoneSyncManager
import java.util.UUID
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

/**
 * 혈압 알림을 관리하는 클래스입니다. 혈압 측정값을 받아 역치와 비교하고, 필요한 경우 알림을 생성하고 전송합니다.
 *
 * @param phoneSyncManager 폰과 데이터 동기화를 관리하는 매니저입니다.
 * @param scope 코루틴 스코프입니다.
 * @param thresholds 혈압 역치 설정입니다.
 */
class BloodPressureAlertManager(
    private val phoneSyncManager: PhoneSyncManager,
    private val scope: CoroutineScope,
    private val thresholds: BloodPressureThresholds = BloodPressureThresholds()
) {

    private val queueMutex = Mutex()
    private val flushMutex = Mutex()
    private val alertQueue = ArrayDeque<BloodPressureAlert>()
    @Volatile
    private var autoSyncEnabled = true

    /**
     * 새로운 혈압 측정값을 제출합니다. 역치를 초과하면 알림을 생성하고 큐에 추가합니다.
     *
     * @param reading 새로운 혈압 측정값입니다.
     */
    fun submitReading(reading: BloodPressureReading) {
        BloodPressureRepository.updateReading(reading)
        thresholds.classify(reading)?.let { severity ->
            val alert = BloodPressureAlert(
                id = UUID.randomUUID().toString(),
                reading = reading,
                severity = severity,
                createdAt = System.currentTimeMillis(),
                status = BloodPressureAlert.Status.Pending,
                failureCount = 0
            )
            enqueueAlert(alert)
        }
    }

    /**
     * 보류 중인 알림을 즉시 전송합니다. 자동 동기화가 활성화된 경우에만 작동합니다.
     */
    fun flushPending() {
        if (!autoSyncEnabled) return
        scope.launch {
            flushQueue()
        }
    }

    /**
     * 자동 동기화 설정을 변경합니다. 활성화되면 보류 중인 알림을 전송합니다.
     *
     * @param enabled 자동 동기화 활성화 여부입니다.
     */
    fun setAutoSyncEnabled(enabled: Boolean) {
        autoSyncEnabled = enabled
        if (enabled) {
            flushPending()
        }
    }

    /**
     * 알림을 큐에 추가하고 `BloodPressureRepository`를 업데이트합니다.
     *
     * @param alert 큐에 추가할 혈압 알림입니다.
     */
    private fun enqueueAlert(alert: BloodPressureAlert) {
        BloodPressureRepository.upsertAlert(alert)
        scope.launch {
            queueMutex.withLock {
                alertQueue.addLast(alert)
            }
            if (autoSyncEnabled) {
                flushQueue()
            }
        }
    }

    /**
     * 큐에 있는 알림들을 순차적으로 처리하여 폰으로 전송합니다. 전송 실패 시 알림을 다시 큐의 맨 앞에 추가합니다.
     */
    private suspend fun flushQueue() {
        if (!autoSyncEnabled) return
        flushMutex.lock()
        try {
            while (true) {
                if (!autoSyncEnabled) break
                val next = queueMutex.withLock {
                    if (alertQueue.isEmpty()) null else alertQueue.removeFirst()
                } ?: break

                val inflight = next.copy(status = BloodPressureAlert.Status.Sending)
                BloodPressureRepository.upsertAlert(inflight)

                val success = runCatching {
                    phoneSyncManager.sendBloodPressureAlert(inflight)
                }.getOrDefault(false)

                val finalStatus = if (success) {
                    BloodPressureAlert.Status.Delivered
                } else {
                    BloodPressureAlert.Status.Pending
                }
                val updated = inflight.copy(
                    status = finalStatus,
                    failureCount = inflight.failureCount + if (success) 0 else 1
                )
                BloodPressureRepository.upsertAlert(updated)

                if (!success) {
                    queueMutex.withLock {
                        alertQueue.addFirst(updated)
                    }
                    break
                }
            }
        } finally {
            flushMutex.unlock()
        }
    }
}

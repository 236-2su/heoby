package com.sunshinemoongit.heoby.heoby_android.data.model

/**
 * 혈압 관련 알림을 나타내는 데이터 클래스입니다.
 *
 * @property id 알림의 고유 ID.
 * @property reading 알림을 발생시킨 혈압 측정값.
 * @property severity 알림의 심각도.
 * @property createdAt 알림 생성 시간 (Epoch 밀리초).
 * @property status 알림의 현재 상태 (전송 대기, 전송 중, 전송 완료).
 * @property failureCount 알림 전송 실패 횟수.
 */
data class BloodPressureAlert(
    val id: String,
    val reading: BloodPressureReading,
    val severity: BloodPressureAlertSeverity,
    val createdAt: Long,
    val status: Status,
    val failureCount: Int
) {
    /**
     * 혈압 알림의 상태를 나타내는 열거형 클래스입니다.
     */
    enum class Status {
        /** 알림이 전송 대기 중입니다. */
        Pending,
        /** 알림이 전송 중입니다. */
        Sending,
        /** 알림이 성공적으로 전송되었습니다. */
        Delivered
    }
}

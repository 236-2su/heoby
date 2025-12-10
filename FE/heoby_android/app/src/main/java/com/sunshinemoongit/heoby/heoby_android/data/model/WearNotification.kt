package com.sunshinemoongit.heoby.heoby_android.data.model

/**
 * Wear OS에 표시될 알림을 나타내는 데이터 클래스입니다.
 *
 * @property id 알림의 고유 ID.
 * @property title 알림의 제목.
 * @property message 알림의 내용.
 * @property timestamp 알림이 생성된 시간 (Epoch 밀리초).
 */
data class WearNotification(
    val id: String,
    val title: String,
    val message: String,
    val timestamp: Long
)


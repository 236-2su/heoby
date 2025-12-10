package com.sunshinemoongit.heoby.heoby_android.data.notifications

import com.sunshinemoongit.heoby.heoby_android.data.model.WearNotification
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

/**
 * Wear OS 알림을 관리하는 싱글톤 객체입니다.
 */
object NotificationRepository {
    // 알림 목록을 저장하는 StateFlow
    private val _notifications = MutableStateFlow<List<WearNotification>>(emptyList())
    val notifications: StateFlow<List<WearNotification>> = _notifications.asStateFlow()

    /**
     * 알림을 추가하거나 업데이트합니다. 동일한 ID의 알림이 이미 존재하면 업데이트하고, 그렇지 않으면 새로 추가합니다.
     *
     * @param notification 추가하거나 업데이트할 알림입니다.
     */
    fun upsert(notification: WearNotification) {
        _notifications.update { current ->
            val mutable = current.toMutableList()
            val index = mutable.indexOfFirst { it.id == notification.id }
            if (index >= 0) {
                mutable[index] = notification
            } else {
                mutable.add(0, notification)
            }
            mutable
        }
    }
}


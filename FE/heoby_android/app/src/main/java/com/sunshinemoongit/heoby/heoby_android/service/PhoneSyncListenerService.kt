package com.sunshinemoongit.heoby.heoby_android.service

import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import com.sunshinemoongit.heoby.heoby_android.data.model.WearNotification
import com.sunshinemoongit.heoby.heoby_android.data.notifications.NotificationRepository
import com.sunshinemoongit.heoby.heoby_android.data.phone.DataLayerPaths
import org.json.JSONObject

/**
 * 폰으로부터 Wearable Data Layer 메시지를 수신하는 서비스입니다.
 */
class PhoneSyncListenerService : WearableListenerService() {

    /**
     * 메시지가 수신되었을 때 호출됩니다. 알림 메시지를 처리합니다.
     *
     * @param messageEvent 수신된 메시지 이벤트입니다.
     */
    override fun onMessageReceived(messageEvent: MessageEvent) {
        if (messageEvent.path == DataLayerPaths.PATH_NOTIFICATION) {
            handleNotification(messageEvent.data)
        } else {
            super.onMessageReceived(messageEvent)
        }
    }

    /**
     * 수신된 알림 페이로드를 처리하여 `NotificationRepository`에 저장합니다.
     *
     * @param payload 알림 데이터 페이로드입니다.
     */
    private fun handleNotification(payload: ByteArray) {
        runCatching {
            val json = JSONObject(String(payload, Charsets.UTF_8))
            val notification = WearNotification(
                id = json.optString("id", json.optString("notificationId", "")),
                title = json.optString("title"),
                message = json.optString("body"),
                timestamp = json.optLong("timestamp", System.currentTimeMillis())
            )
            NotificationRepository.upsert(notification)
        }
    }
}

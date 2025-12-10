package com.sunshinemoongit.heoby_mobile

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

/**
 * 백그라운드에서 Wear OS로부터 혈압 알림을 수신하는 서비스
 */
class BloodPressureListenerService : WearableListenerService() {

    companion object {
        private const val TAG = "BloodPressureService"
        private const val PATH_BLOOD_PRESSURE_ALERT = "/watch/blood_pressure_alert"
        private const val CHANNEL_ID = "blood_pressure_alerts"
        private const val CHANNEL_NAME = "혈압 알림"
        private const val NOTIFICATION_ID_BASE = 2000
        private const val API_BASE_URL = "https://k13e106.p.ssafy.io/dev/api"
        private const val API_ENDPOINT = "/notifications/blood-pressure"
    }

    private val httpClient = OkHttpClient.Builder()
        .connectTimeout(10, TimeUnit.SECONDS)
        .writeTimeout(10, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .build()

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "BloodPressureListenerService created")
        createNotificationChannel()
    }

    override fun onMessageReceived(event: MessageEvent) {
        Log.d(TAG, "Message received: path=${event.path}")

        if (event.path == PATH_BLOOD_PRESSURE_ALERT) {
            try {
                val payload = String(event.data, Charsets.UTF_8)
                Log.d(TAG, "Blood pressure alert received: $payload")

                val jsonObject = JSONObject(payload)
                val systolic = jsonObject.getInt("systolic")
                val diastolic = jsonObject.getInt("diastolic")
                val severity = jsonObject.getString("severity")
                val alertId = jsonObject.getString("alertId")
                val timestamp = jsonObject.getLong("timestamp")

                // 백엔드로 데이터 전송
                sendToBackend(jsonObject)

                // 로컬 알림 표시
                showNotification(systolic, diastolic, severity, alertId)

            } catch (e: Exception) {
                Log.e(TAG, "Error processing blood pressure alert", e)
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                importance
            ).apply {
                description = "워치에서 측정된 혈압이 위험 수준일 때 알림을 받습니다"
                enableVibration(true)
                setShowBadge(true)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
            Log.d(TAG, "Notification channel created: $CHANNEL_ID")
        }
    }

    private fun showNotification(systolic: Int, diastolic: Int, severity: String, alertId: String) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // 심각도에 따른 텍스트
        val severityText = if (severity == "Critical") "위험" else "주의"
        val title = "⚠️ 혈압 $severityText 알림"
        val message = "혈압: $systolic/$diastolic mmHg\n즉시 확인이 필요합니다."

        // 앱을 여는 Intent
        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // 알림 우선순위 설정 (심각도에 따라)
        val priority = if (severity == "Critical") {
            NotificationCompat.PRIORITY_MAX
        } else {
            NotificationCompat.PRIORITY_HIGH
        }

        // 알림 생성
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle(title)
            .setContentText(message)
            .setStyle(NotificationCompat.BigTextStyle().bigText(message))
            .setPriority(priority)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .setVibrate(longArrayOf(0, 500, 200, 500))
            .build()

        // 고유한 알림 ID 생성 (alertId 해시 사용)
        val notificationId = NOTIFICATION_ID_BASE + alertId.hashCode() % 1000

        notificationManager.notify(notificationId, notification)
        Log.d(TAG, "Notification shown: id=$notificationId, severity=$severity")
    }

    /**
     * 백엔드 서버로 혈압 알림 데이터 전송
     */
    private fun sendToBackend(data: JSONObject) {
        try {
            val url = "$API_BASE_URL$API_ENDPOINT"

            // 요청 바디 생성 (백엔드에서 요구하는 형식에 맞게 수정)
            val requestBody = data.toString()
                .toRequestBody("application/json; charset=utf-8".toMediaType())

            val request = Request.Builder()
                .url(url)
                .post(requestBody)
                .addHeader("Content-Type", "application/json")
                .build()

            Log.d(TAG, "Sending blood pressure data to backend: $url")
            Log.d(TAG, "Request body: ${data.toString()}")

            httpClient.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    Log.e(TAG, "Failed to send data to backend", e)
                }

                override fun onResponse(call: Call, response: Response) {
                    response.use {
                        if (it.isSuccessful) {
                            Log.d(TAG, "Successfully sent blood pressure data to backend: ${it.code}")
                            Log.d(TAG, "Response: ${it.body?.string()}")
                        } else {
                            Log.e(TAG, "Backend returned error: ${it.code}")
                            Log.e(TAG, "Error body: ${it.body?.string()}")
                        }
                    }
                }
            })
        } catch (e: Exception) {
            Log.e(TAG, "Error sending data to backend", e)
        }
    }
}

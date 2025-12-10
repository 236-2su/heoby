package com.sunshinemoongit.heoby_mobile

import android.os.Bundle
import android.util.Log
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.MessageClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val TAG = "MainActivity"
    private val CHANNEL = "com.sunshinemoongit.heoby_mobile/wearable"
    private val PATH_NOTIFICATION = "/phone/notification"
    private val PATH_BLOOD_PRESSURE_ALERT = "/watch/blood_pressure_alert"

    private lateinit var messageClient: MessageClient
    private var methodChannel: MethodChannel? = null

    private val messageListener = MessageClient.OnMessageReceivedListener { event ->
        Log.d(TAG, "Message received from watch: path=${event.path}")
        when (event.path) {
            PATH_BLOOD_PRESSURE_ALERT -> {
                try {
                    val payload = String(event.data, Charsets.UTF_8)
                    Log.d(TAG, "Blood pressure alert received: $payload")
                    val jsonObject = JSONObject(payload)

                    val alertData = mapOf(
                        "alertId" to jsonObject.getString("alertId"),
                        "systolic" to jsonObject.getInt("systolic"),
                        "diastolic" to jsonObject.getInt("diastolic"),
                        "severity" to jsonObject.getString("severity"),
                        "timestamp" to jsonObject.getLong("timestamp"),
                        "createdAt" to jsonObject.getLong("createdAt")
                    )

                    runOnUiThread {
                        methodChannel?.invokeMethod("onBloodPressureAlert", alertData)
                        Log.d(TAG, "Blood pressure alert sent to Flutter: $alertData")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error processing blood pressure alert", e)
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        messageClient = Wearable.getMessageClient(this)
        messageClient.addListener(messageListener)
        Log.d(TAG, "MainActivity created, MessageClient and listener initialized")

        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            methodChannel = MethodChannel(messenger, CHANNEL).apply {
                setMethodCallHandler { call, result ->
                    when (call.method) {
                        "sendNotificationToWatch" -> {
                            val title = call.argument<String>("title") ?: ""
                            val body = call.argument<String>("body") ?: ""
                            val notificationId = call.argument<String>("notificationId") ?: ""
                            val iconName = call.argument<String>("iconName") ?: "ic_launcher"

                            Log.d(TAG, "Received sendNotificationToWatch call: title=$title, body=$body, icon=$iconName")
                            sendNotificationToWatch(title, body, notificationId, iconName)
                            result.success(true)
                        }
                        else -> result.notImplemented()
                    }
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        messageClient.removeListener(messageListener)
        Log.d(TAG, "MessageClient listener removed")
    }

    private fun sendNotificationToWatch(title: String, body: String, notificationId: String, iconName: String) {
        val json = JSONObject().apply {
            put("title", title)
            put("body", body)
            put("notificationId", notificationId)
            put("timestamp", System.currentTimeMillis())
            put("iconName", iconName)
        }

        val payload = json.toString().toByteArray(Charsets.UTF_8)
        Log.d(TAG, "Prepared notification payload: ${json.toString()}")

        Wearable.getNodeClient(this).connectedNodes.addOnSuccessListener { nodes ->
            Log.d(TAG, "Connected nodes count: ${nodes.size}")
            if (nodes.isEmpty()) {
                Log.w(TAG, "No connected wearable devices found!")
            }
            nodes.forEach { node ->
                Log.d(TAG, "Sending message to node: ${node.displayName} (${node.id})")
                messageClient.sendMessage(node.id, PATH_NOTIFICATION, payload)
                    .addOnSuccessListener {
                        Log.d(TAG, "Message sent successfully to ${node.displayName}")
                    }
                    .addOnFailureListener { e ->
                        Log.e(TAG, "Failed to send message to ${node.displayName}: ${e.message}")
                    }
            }
        }.addOnFailureListener { e ->
            Log.e(TAG, "Failed to get connected nodes: ${e.message}")
        }
    }
}

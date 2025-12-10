package com.sunshinemoongit.heoby.heoby_android.data.phone

import android.content.Context
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureAlert
import com.sunshinemoongit.heoby.heoby_android.data.model.HealthMetrics
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import org.json.JSONObject
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.Wearable

/**
 * 폰과의 데이터 동기화를 관리하는 클래스입니다. Wearable Data Layer를 사용하여 폰과 통신합니다.
 *
 * @param context 애플리케이션 컨텍스트입니다.
 * @param scope 코루틴 스코프입니다.
 */
class PhoneSyncManager(
    context: Context,
    private val scope: CoroutineScope
) {

    /**
     * 폰과의 연결 상태를 나타내는 열거형 클래스입니다.
     */
    enum class ConnectionState {
        /** 폰에 연결되었습니다. */
        Connected,
        /** 폰과의 연결이 끊어졌습니다. */
        Disconnected
    }

    private val messageClient: MessageClient = Wearable.getMessageClient(context)
    private val nodeClient: NodeClient = Wearable.getNodeClient(context)

    // 폰으로부터 핑 메시지를 수신하는 리스너
    private val phonePingListener = MessageClient.OnMessageReceivedListener { event ->
        if (event.path == DataLayerPaths.PATH_PHONE_PING) {
            _connectionState.value = ConnectionState.Connected
        }
    }

    private var listenJob: Job? = null

    // 폰과의 연결 상태를 나타내는 StateFlow
    private val _connectionState = MutableStateFlow(ConnectionState.Disconnected)
    val connectionState: StateFlow<ConnectionState> = _connectionState.asStateFlow()

    /**
     * 데이터 동기화 관리자를 시작합니다. 메시지 리스너를 등록하고 연결 상태를 확인합니다.
     */
    fun start() {
        listenJob?.cancel()
        listenJob = scope.launch(Dispatchers.IO) {
            messageClient.addListener(phonePingListener)
            refreshConnectionState()
            sendReadySignal()
        }
    }

    /**
     * 데이터 동기화 관리자를 중지합니다. 메시지 리스너를 해제합니다.
     */
    fun stop() {
        listenJob?.cancel()
        messageClient.removeListener(phonePingListener)
    }

    /**
     * 폰과의 연결 상태를 새로고침합니다.
     */
    fun refreshConnectionState() {
        scope.launch(Dispatchers.IO) {
            runCatching {
                nodeClient.connectedNodes.await()
            }.onSuccess { nodes ->
                _connectionState.value = if (nodes.isNotEmpty()) {
                    ConnectionState.Connected
                } else {
                    ConnectionState.Disconnected
                }
            }.onFailure {
                _connectionState.value = ConnectionState.Disconnected
            }
        }
    }

    /**
     * 건강 지표 데이터를 폰으로 전송합니다.
     *
     * @param metrics 전송할 건강 지표 데이터입니다.
     * @return 전송 성공 여부입니다.
     */
    suspend fun sendHealthMetrics(metrics: HealthMetrics): Boolean {
        val payload = JSONObject().apply {
            metrics.heartRateBpm?.let { put("heartRateBpm", it) }
            metrics.stepsSinceBoot?.let { put("steps", it) }
            put("timestamp", metrics.lastUpdatedEpochMillis)
        }.toString().encodeToByteArray()

        return sendPayloadToAllNodes(DataLayerPaths.PATH_HEALTH_METRICS, payload)
    }

    /**
     * 혈압 경고를 폰으로 전송합니다.
     *
     * @param alert 전송할 혈압 경고입니다.
     * @return 전송 성공 여부입니다.
     */
    suspend fun sendBloodPressureAlert(alert: BloodPressureAlert): Boolean {
        val reading = alert.reading
        val payload = JSONObject().apply {
            put("alertId", alert.id)
            put("systolic", reading.systolic)
            put("diastolic", reading.diastolic)
            put("severity", alert.severity.name)
            put("timestamp", reading.timestamp)
            put("createdAt", alert.createdAt)
        }.toString().encodeToByteArray()

        return sendPayloadToAllNodes(DataLayerPaths.PATH_BLOOD_PRESSURE_ALERT, payload)
    }

    /**
     * 워치가 준비되었음을 알리는 신호를 폰으로 전송합니다.
     */
    private fun sendReadySignal() {
        scope.launch(Dispatchers.IO) {
            sendPayloadToAllNodes(DataLayerPaths.PATH_WATCH_READY, ByteArray(0))
        }
    }

    /**
     * 페이로드를 연결된 모든 노드(폰)에 전송합니다.
     *
     * @param path 데이터 경로입니다.
     * @param payload 전송할 데이터입니다.
     * @return 전송 성공 여부입니다.
     */
    private suspend fun sendPayloadToAllNodes(path: String, payload: ByteArray): Boolean =
        withContext(Dispatchers.IO) {
            val nodes = runCatching { nodeClient.connectedNodes.await() }.getOrNull().orEmpty()
            if (nodes.isEmpty()) {
                _connectionState.value = ConnectionState.Disconnected
                return@withContext false
            }

            var delivered = false
            nodes.forEach { node ->
                runCatching {
                    messageClient.sendMessage(node.id, path, payload).await()
                }.onSuccess {
                    _connectionState.value = ConnectionState.Connected
                    delivered = true
                }.onFailure {
                    _connectionState.value = ConnectionState.Disconnected
                }
            }
            delivered
    }
}


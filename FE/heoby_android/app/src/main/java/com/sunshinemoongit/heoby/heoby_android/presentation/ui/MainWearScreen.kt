package com.sunshinemoongit.heoby.heoby_android.presentation.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.unit.dp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.ScalingLazyListAnchorType
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material.TimeText
import androidx.wear.compose.material.Scaffold
import androidx.compose.ui.graphics.Brush
import androidx.wear.compose.material.Vignette
import androidx.wear.compose.material.VignettePosition
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureReading
import com.sunshinemoongit.heoby.heoby_android.data.model.WearNotification
import com.sunshinemoongit.heoby.heoby_android.data.phone.PhoneSyncManager
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.components.AutoSyncCard
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.components.RealTimeBloodPressureCard
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.components.notificationSection

/**
 * Wear OS 앱의 메인 화면을 구성하는 컴포저블 함수입니다.
 *
 * @param state 화면의 상태를 나타내는 `WearScreenState` 객체입니다.
 * @param onToggleAutoSync 자동 동기화 설정을 토글하는 람다 함수입니다.
 */
@Composable
fun WearMainScreen(
    state: WearScreenState,
    onToggleAutoSync: () -> Unit
) {
    val listState = rememberScalingLazyListState(
        initialCenterItemIndex = 0
    )
    val gradientBrush = remember {
        Brush.linearGradient(
            colors = listOf(GradientStart, GradientEnd),
            start = Offset.Zero,
            end = Offset(800f, 800f)
        )
    }
    val recentNotifications = remember(state.notifications) { state.notifications.take(5) }

    Scaffold(
        timeText = null,
        vignette = { Vignette(vignettePosition = VignettePosition.TopAndBottom) },
    ) {
        ScalingLazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .background(gradientBrush),
            state = listState,
            anchorType = ScalingLazyListAnchorType.ItemStart,

            contentPadding = PaddingValues(
                start = 8.dp,
                end = 8.dp,
                top = 4.dp,
                bottom = 12.dp
            ),
        ) {
            item { RealTimeBloodPressureCard(reading = state.bloodPressureReading) }
            item { Spacer(modifier = Modifier.height(6.dp)) }
            notificationSection(notifications = recentNotifications)
            item { Spacer(modifier = Modifier.height(6.dp)) }
            item {
                AutoSyncCard(
                    connectionState = state.connectionState,
                    autoSyncEnabled = state.autoSyncEnabled,
                    onToggleAutoSync = onToggleAutoSync
                )
            }
            item {
                AutoSyncCard(
                    connectionState = state.connectionState,
                    autoSyncEnabled = state.autoSyncEnabled,
                    onToggleAutoSync = onToggleAutoSync
                )
            }
        }
    }
}

/**
 * `WearMainScreen`의 UI 상태를 나타내는 데이터 클래스입니다.
 *
 * @property connectionState 폰과의 연결 상태입니다.
 * @property bloodPressureReading 최근 혈압 측정값입니다.
 * @property notifications 알림 목록입니다.
 * @property autoSyncEnabled 자동 동기화 활성화 여부입니다.
 */
data class WearScreenState(
    val connectionState: PhoneSyncManager.ConnectionState,
    val bloodPressureReading: BloodPressureReading?,
    val notifications: List<WearNotification>,
    val autoSyncEnabled: Boolean
)

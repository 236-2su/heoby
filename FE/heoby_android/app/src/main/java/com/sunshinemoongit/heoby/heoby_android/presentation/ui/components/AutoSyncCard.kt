package com.sunshinemoongit.heoby.heoby_android.presentation.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.ButtonDefaults
import androidx.wear.compose.material.Card
import androidx.wear.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sunshinemoongit.heoby.heoby_android.data.phone.PhoneSyncManager
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.AccentDisabled
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.AccentPrimary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.SurfacePrimary

/**
 * 자동 동기화 상태를 표시하고 제어하는 UI 카드 컴포저블입니다.
 *
 * @param connectionState 폰과의 연결 상태입니다.
 * @param autoSyncEnabled 자동 동기화 활성화 여부입니다.
 * @param onToggleAutoSync 자동 동기화 설정을 토글하는 람다 함수입니다.
 */
@Composable
fun AutoSyncCard(
    connectionState: PhoneSyncManager.ConnectionState,
    autoSyncEnabled: Boolean,
    onToggleAutoSync: () -> Unit
) {
    val buttonText = if (autoSyncEnabled) "자동 전송 중" else "자동 전송 꺼짐"
    val buttonColor = if (autoSyncEnabled) AccentPrimary else AccentDisabled
    val enabled = connectionState == PhoneSyncManager.ConnectionState.Connected

    Button(
        onClick = onToggleAutoSync,
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp, horizontal = 6.dp),
        enabled = enabled,
        colors = ButtonDefaults.buttonColors(
            backgroundColor = buttonColor,
            contentColor = Color.White,
            disabledBackgroundColor = AccentDisabled,
            disabledContentColor = Color.White
        )
    ) {
        Text(text = buttonText, fontSize = 12.sp, fontWeight = FontWeight.Bold)
    }
}

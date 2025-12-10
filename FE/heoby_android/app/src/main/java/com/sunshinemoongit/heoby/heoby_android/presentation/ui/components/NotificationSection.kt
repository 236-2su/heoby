package com.sunshinemoongit.heoby.heoby_android.presentation.ui.components

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.wear.compose.foundation.lazy.items
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.ButtonDefaults
import androidx.wear.compose.material.Card
import androidx.wear.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.graphics.Color
import androidx.wear.compose.foundation.lazy.ScalingLazyListScope
import androidx.wear.remote.interactions.RemoteActivityHelper
import com.sunshinemoongit.heoby.heoby_android.data.model.WearNotification
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.AccentPrimary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.SurfacePrimary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.TextPrimary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.TextSecondary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.formatTimestamp
import kotlinx.coroutines.guava.await
import kotlinx.coroutines.launch

/**
 * `ScalingLazyList` 내에서 최근 알림 목록을 표시하는 확장 함수입니다.
 *
 * @param notifications 표시할 알림 목록입니다.
 * @param emptyMessage 알림이 없을 때 표시할 메시지입니다.
 */
fun ScalingLazyListScope.notificationSection(
    notifications: List<WearNotification>,
    emptyMessage: String = "알림이 없습니다."
) {
    item {
        Text(
            text = "최근 알림",
            color = TextPrimary,
            fontWeight = FontWeight.Bold,
            fontSize = 20.sp,
            modifier = Modifier.padding(top = 8.dp, bottom = 4.dp)
        )
    }

    if (notifications.isEmpty()) {
        item {
            Text(
                text = emptyMessage,
                color = TextSecondary,
                fontSize = 16.sp,
                modifier = Modifier.padding(horizontal = 8.dp, vertical = 12.dp)
            )
        }
    } else {
        items(notifications) { notification ->
            NotificationRow(notification)
        }
    }
}

/**
 * 단일 알림 항목을 표시하는 컴포저블 함수입니다.
 *
 * @param item 표시할 알림 객체입니다.
 */
@Composable
private fun NotificationRow(item: WearNotification) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        onClick = {}
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(SurfacePrimary)
                .padding(8.dp)
        ) {
            Text(
                text = item.title.ifEmpty { "새 알림" },
                color = TextPrimary,
                fontSize = 11.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                text = item.message,
                color = TextSecondary,
                fontSize = 10.sp
            )
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                text = formatTimestamp(item.timestamp),
                color = TextSecondary,
                fontSize = 9.sp
            )
            Spacer(modifier = Modifier.height(4.dp))
            Button(
                onClick = {
                    scope.launch {
                        openOnPhone(context, item.id)
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    backgroundColor = AccentPrimary,
                    contentColor = Color.White
                )
            ) {
                Text(
                    text = "폰에서 보기",
                    fontSize = 10.sp,
                    color = Color.White
                )
            }
        }
    }
}

/**
 * 폰에서 특정 알림을 열도록 원격 인텐트를 실행하는 일시 중단 함수입니다.
 *
 * @param context 애플리케이션 컨텍스트입니다.
 * @param notificationId 열고자 하는 알림의 ID입니다.
 */
private suspend fun openOnPhone(context: android.content.Context, notificationId: String) {
    val remoteActivityHelper = RemoteActivityHelper(context)
    val intent = Intent(Intent.ACTION_VIEW).apply {
        setPackage("com.sunshinemoongit.heoby")
        data = Uri.parse("heoby://notification/$notificationId")
        addCategory(Intent.CATEGORY_BROWSABLE)
    }
    remoteActivityHelper.startRemoteActivity(intent).await()
}

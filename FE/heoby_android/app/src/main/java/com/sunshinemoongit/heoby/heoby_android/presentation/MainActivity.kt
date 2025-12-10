package com.sunshinemoongit.heoby.heoby_android.presentation

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.wear.tooling.preview.devices.WearDevices
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureReading
import com.sunshinemoongit.heoby.heoby_android.data.model.WearNotification
import com.sunshinemoongit.heoby.heoby_android.data.phone.PhoneSyncManager
import com.sunshinemoongit.heoby.heoby_android.presentation.theme.Heoby_androidTheme
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.WearMainScreen
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.WearScreenState

/**
 * Wear OS 애플리케이션의 메인 액티비티입니다.
 */
class MainActivity : ComponentActivity() {

    // 센서 데이터 접근에 필요한 권한 배열
    private val sensorPermissions = arrayOf(
        Manifest.permission.BODY_SENSORS,
        Manifest.permission.BODY_SENSORS_BACKGROUND,
        Manifest.permission.ACTIVITY_RECOGNITION
    )
    // 메인 뷰모델 인스턴스
    private val mainViewModel: MainViewModel by viewModels()

    /**
     * 액티비티가 생성될 때 호출됩니다.
     * 스플래시 스크린, 테마 및 UI 콘텐츠를 설정합니다.
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)

        setTheme(android.R.style.Theme_DeviceDefault)

        setContent {
            Heoby_androidTheme {
                WearApp(
                    viewModel = mainViewModel,
                    sensorPermissions = sensorPermissions
                )
            }
        }
    }
}

/**
 * Wear OS 앱의 메인 UI를 구성하는 컴포저블 함수입니다.
 *
 * @param viewModel MainViewModel 인스턴스. UI 상태를 관리합니다.
 * @param sensorPermissions 필요한 센서 권한의 배열입니다.
 */
@Composable
fun WearApp(
    viewModel: MainViewModel,
    sensorPermissions: Array<String>
) {
    val context = LocalContext.current

    // 뷰모델로부터 UI 상태를 구독합니다.
    val connectionState by viewModel.connectionState.collectAsState()
    val bloodPressureReading by viewModel.bloodPressureReading.collectAsState()
    val notifications by viewModel.notifications.collectAsState()
    val autoSyncEnabled by viewModel.autoSyncEnabled.collectAsState()

    // 권한 요청을 위한 런처를 설정합니다.
    val permissionLauncher =
        rememberLauncherForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { result ->
            val granted = sensorPermissions.all { result[it] == true }
            viewModel.onSensorsPermissionResult(granted)
        }

    // 컴포저블이 처음 호출될 때 권한을 확인하고 요청합니다.
    LaunchedEffect(Unit) {
        val alreadyGranted = sensorPermissions.all {
            ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
        }
        if (alreadyGranted) {
            viewModel.onSensorsPermissionResult(true)
        } else {
            permissionLauncher.launch(sensorPermissions)
        }

        // 테스트: 위험 수준의 혈압 알림 전송
        viewModel.recordBloodPressure(165, 105)
    }

    // 메인 화면을 렌더링합니다.
    WearMainScreen(
        state = WearScreenState(
            connectionState = connectionState,
            bloodPressureReading = bloodPressureReading,
            notifications = notifications,
            autoSyncEnabled = autoSyncEnabled
        ),
        onToggleAutoSync = {
            viewModel.toggleAutoSync()
        }
    )
}

/**
 * Android Studio에서 `WearMainScreen`을 미리보기 위한 컴포저블 함수입니다.
 */
@androidx.compose.ui.tooling.preview.Preview(
    device = WearDevices.SMALL_ROUND,
    showSystemUi = true
)
@Composable
private fun PreviewWearApp() {
    Heoby_androidTheme {
        WearMainScreen(
            state = WearScreenState(
                connectionState = PhoneSyncManager.ConnectionState.Connected,
                bloodPressureReading = BloodPressureReading(
                    systolic = 150,
                    diastolic = 95,
                    timestamp = System.currentTimeMillis(),
                    source = BloodPressureReading.Source.ManualDebug
                ),
                notifications = listOf(
                    WearNotification(
                        id = "demo",
                        title = "Sample notification",
                        message = "The message body from the phone appears here.",
                        timestamp = System.currentTimeMillis()
                    )
                ),
                autoSyncEnabled = true
            ),
            onToggleAutoSync = {}
        )
    }
}

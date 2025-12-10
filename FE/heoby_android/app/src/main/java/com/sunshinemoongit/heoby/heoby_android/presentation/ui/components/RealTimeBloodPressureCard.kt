package com.sunshinemoongit.heoby.heoby_android.presentation.ui.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.material.Card
import androidx.wear.compose.material.CardDefaults
import androidx.wear.compose.material.Text
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureAlertSeverity
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureReading
import com.sunshinemoongit.heoby.heoby_android.data.model.BloodPressureThresholds
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.SurfacePrimary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.SeverityCritical
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.SeverityNormal
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.SeverityWarning
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.TextPrimary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.TextSecondary
import com.sunshinemoongit.heoby.heoby_android.presentation.ui.formatMeasurementTimestamp

/**
 * 실시간 혈압 정보를 표시하는 UI 카드 컴포저블입니다.
 *
 * @param reading 표시할 혈압 측정값입니다. null인 경우 측정 기록이 없음을 나타냅니다.
 */
@Composable
fun RealTimeBloodPressureCard(
    reading: BloodPressureReading?
) {
    val thresholds = remember { BloodPressureThresholds() }
    val severity = reading?.let { thresholds.classify(it) }
    val measurementText = reading?.let { "${it.systolic}/${it.diastolic} mmHg" } ?: "최근 측정 없음"
    val measurementColor = when (severity) {
        BloodPressureAlertSeverity.Critical -> SeverityCritical
        BloodPressureAlertSeverity.Warning -> SeverityWarning
        null -> if (reading == null) TextSecondary else SeverityNormal
    }
    val timestampText = reading?.let { formatMeasurementTimestamp(it.timestamp) }
        ?: "마지막 측정: 기록 없음"

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp),
        horizontalAlignment = Alignment.CenterHorizontally

    ) {
        Spacer(modifier = Modifier.height(16.dp))
        Text(
            text = "실시간 혈압 정보",
            fontWeight = FontWeight.Bold,
            color = TextPrimary,
            fontSize = 20.sp,
            letterSpacing = (-0.5).sp
        )
        Spacer(modifier = Modifier.height(8.dp))

        Card(
            onClick = {},
            modifier = Modifier.fillMaxWidth(),
            backgroundPainter = CardDefaults.cardBackgroundPainter(
                startBackgroundColor = SurfacePrimary,
                endBackgroundColor = SurfacePrimary
            )
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 10.dp, horizontal = 6.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = measurementText,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Black,
                    color = measurementColor
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = timestampText,
                    color = TextPrimary,
                    fontSize = 11.sp
                )
            }
        }
    }
}

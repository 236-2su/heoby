package com.sunshinemoongit.heoby.heoby_android.data.model

/**
 * 혈압 측정값을 나타내는 데이터 클래스입니다.
 *
 * @property systolic 수축기 혈압.
 * @property diastolic 이완기 혈압.
 * @property timestamp 측정 시간 (Epoch 밀리초).
 * @property source 데이터 소스 (수동 디_tool_code
bug 또는 센서).
 */
data class BloodPressureReading(
    val systolic: Int,
    val diastolic: Int,
    val timestamp: Long,
    val source: Source
) {
    /**
     * 혈압 데이터의 소스를 나타내는 열거형 클래스입니다.
     */
    enum class Source {
        /** 수동으로 입력된 디버그용 데이터입니다. */
        ManualDebug,
        /** 센서로부터 수집된 데이터입니다. */
        Sensor
    }
}

/**
 * 혈압 경고 역치를 정의하는 데이터 클래스입니다.
 *
 * @property warningSystolic '주의' 단계의 수축기 혈압 역치.
 * @property warningDiastolic '주의' 단계의 이완기 혈압 역치.
 * @property criticalSystolic '위험' 단계의 수축기 혈압 역치.
 * @property criticalDiastolic '위험' 단계의 이완기 혈압 역치.
 */
data class BloodPressureThresholds(
    val warningSystolic: Int = 140,
    val warningDiastolic: Int = 90,
    val criticalSystolic: Int = 160,
    val criticalDiastolic: Int = 100
) {
    /**
     * 혈압 측정값을 기반으로 심각도를 분류합니다.
     *
     * @param reading 분류할 혈압 측정값.
     * @return '위험', '주의' 또는 null (정상).
     */
    fun classify(reading: BloodPressureReading): BloodPressureAlertSeverity? {
        val (sys, dia) = reading.systolic to reading.diastolic
        return when {
            sys >= criticalSystolic || dia >= criticalDiastolic -> BloodPressureAlertSeverity.Critical
            sys >= warningSystolic || dia >= warningDiastolic -> BloodPressureAlertSeverity.Warning
            else -> null
        }
    }
}

/**
 * 혈압 알림의 심각도를 나타내는 열거형 클래스입니다.
 */
enum class BloodPressureAlertSeverity {
    /** 주의가 필요한 수준입니다. */
    Warning,
    /** 즉각적인 조치가 필요한 위험 수준입니다. */
    Critical
}

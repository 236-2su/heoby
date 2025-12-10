package com.sunshinemoongit.heoby.heoby_android.data.phone

/**
 * Wearable Data Layer에서 사용되는 경로들을 정의하는 싱글톤 객체입니다.
 */
object DataLayerPaths {
    /** 폰에서 워치로 알림을 보낼 때 사용하는 경로입니다. */
    const val PATH_NOTIFICATION = "/phone/notification"
    /** 워치에서 폰으로 건강 지표를 보낼 때 사용하는 경로입니다. */
    const val PATH_HEALTH_METRICS = "/watch/health_metrics"
    /** 워치에서 폰으로 혈압 경고를 보낼 때 사용하는 경로입니다. */
    const val PATH_BLOOD_PRESSURE_ALERT = "/watch/blood_pressure_alert"
    /** 워치가 준비되었음을 폰에 알릴 때 사용하는 경로입니다. */
    const val PATH_WATCH_READY = "/watch/ready"
    /** 폰에서 워치로 핑을 보낼 때 사용하는 경로입니다. */
    const val PATH_PHONE_PING = "/phone/ping"
}


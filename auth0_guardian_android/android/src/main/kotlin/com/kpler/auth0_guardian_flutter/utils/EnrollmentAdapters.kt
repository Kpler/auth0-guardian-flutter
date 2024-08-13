package com.kpler.auth0_guardian_flutter.utils

import com.auth0.android.guardian.sdk.Enrollment

fun Enrollment.toFlutterResult(): Map<String, Any?> {
    return mapOf(
            "id" to id,
            "userId" to userId,
            "deviceToken" to deviceToken,
            "notificationToken" to notificationToken,
            "totp" to totpMap(),
    )
}

private fun Enrollment.totpMap(): Map<String, Any?> {
    return mapOf(
            "base32Secret" to secret,
            "algorithm" to algorithm,
            "digits" to digits,
            "period" to period,
    )
}

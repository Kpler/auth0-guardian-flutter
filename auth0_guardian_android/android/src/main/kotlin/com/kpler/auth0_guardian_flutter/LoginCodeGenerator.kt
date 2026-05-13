package com.kpler.auth0_guardian_flutter

import com.auth0.android.guardian.sdk.otp.TOTP
import com.auth0.android.guardian.sdk.otp.utils.Base32

class LoginCodeGenerator {
    fun getCode(copiedCode: String): String {
        var key: ByteArray
        try {
            key = Base32.decode(copiedCode)
        } catch (ex: Base32.DecodingException) {
            throw IllegalArgumentException("Invalid secret key", ex)
        }
        val totp = TOTP(TOTP_ALGORITHM, key, TOTP_LENGTH, TOTP_DURATION)
        try {
            return totp.generate()
        } catch (ex: Exception) {
            throw RuntimeException("Failed to generate code", ex)
        }

    }
    companion object {
        private const val TOTP_LENGTH = 6
        private const val TOTP_DURATION = 30
        private const val TOTP_ALGORITHM = "SHA1"
    }

}
package com.kpler.auth0_guardian_flutter

import EnrolledDevice
import android.net.Uri
import com.auth0.android.guardian.sdk.Enrollment
import com.auth0.android.guardian.sdk.Guardian
import com.auth0.android.guardian.sdk.networking.Callback
import com.kpler.auth0_guardian_flutter.utils.SigningKeyService
import com.kpler.auth0_guardian_flutter.utils.getGuardianErrorMessage
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class GuardianDeviceFlutter : MethodCallHandler {
    private val methodChannelName = "com.kpler/auth0_guardian_android/device"

    private var channel: MethodChannel

    private var plugin: KotlinFlutterPlugin?

    constructor(plugin: KotlinFlutterPlugin) {
        this.plugin = plugin
        this.channel = MethodChannel(plugin.flutterPluginBinding.binaryMessenger, methodChannelName)
        this.channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments as Map<String, Any>
        when (call.method) {
            "delete" -> delete(args, result)
            else -> result.notImplemented()
        }
    }

    private fun buildGuardian(domain: String): Guardian {
        val url = Uri.parse(domain)
        return Guardian.Builder().url(url).build()
    }

    private fun delete(args: Map<String, Any>, result: MethodChannel.Result) {
        try {
            // Extract the arguments from the method call (Flutter).
            val forDomain = args["forDomain"] as String
            val forEnrollmentId = args["forEnrollmentId"] as String
            val userId = args["userId"] as String

            // Get the signing key.
            val signingKey = SigningKeyService(forDomain).getSigningKey()
            val enrollment: Enrollment = EnrolledDevice(signingKey, userId, forEnrollmentId)

            // Define the callback to handle the enrollment result.
            val callback =
                    object : Callback<Void> {
                        override fun onSuccess(repsonse: Void?) {
                            SigningKeyService(forDomain).deleteSigningKey()
                            result.success(true)
                        }
                        override fun onFailure(exception: Throwable) {
                            result.error(
                                    "DeleteFailure",
                                    getGuardianErrorMessage(
                                            "GuardianDeviceFlutter.delete() failed"
                                    ),
                                    exception.message
                            )
                        }
                    }

            // Start the enrollment process.
            buildGuardian(forDomain).delete(enrollment).start(callback)
        } catch (exception: Exception) {
            result.error(
                    "UnexpectedError",
                    getGuardianErrorMessage(
                            "GuardianDeviceFlutter.delete() thrown an unexpected error"
                    ),
                    exception.message
            )
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        plugin = null
    }
}

package com.kpler.auth0_guardian_flutter

import EnrolledDevice
import android.net.Uri
import com.auth0.android.guardian.sdk.CurrentDevice
import com.auth0.android.guardian.sdk.Enrollment
import com.auth0.android.guardian.sdk.Guardian
import com.auth0.android.guardian.sdk.ParcelableNotification
import com.auth0.android.guardian.sdk.networking.Callback
import com.kpler.auth0_guardian_flutter.utils.SigningKeyService
import com.kpler.auth0_guardian_flutter.utils.getGuardianErrorMessage
import com.kpler.auth0_guardian_flutter.utils.toFlutterResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class GuardianFlutter : MethodCallHandler {
    private val methodChannelName = "com.kpler/auth0_guardian_android/guardian"

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
            "enroll" -> enroll(args, result)
            "acceptRequest" -> acceptRequest(args, result)
            "rejectRequest" -> rejectRequest(args, result)
            "isGuardianNotification" -> isGuardianNotification(args, result)
            else -> result.notImplemented()
        }
    }

    private fun buildGuardian(domain: String): Guardian {
        val url = Uri.parse(domain)
        return Guardian.Builder().url(url).build()
    }

    private fun enroll(args: Map<String, Any>, result: MethodChannel.Result) {
        try {
            // Extract the arguments from the method call (Flutter).
            val forDomain = args["forDomain"] as String
            val usingUri = args["usingUri"] as String
            val notificationToken = args["notificationToken"] as? String

            // Create the device and key pair objects.
            val device = CurrentDevice(plugin!!.context, notificationToken, "Android device")
            val keyPair = SigningKeyService(forDomain).generateSigningKey()

            // Define the callback to handle the enrollment result.
            val callback =
                    object : Callback<Enrollment> {
                        override fun onSuccess(enrollment: Enrollment) {
                            result.success(enrollment.toFlutterResult())
                        }
                        override fun onFailure(exception: Throwable) {
                            result.error(
                                    "EnrollFailure",
                                    getGuardianErrorMessage(
                                            "GuardianFlutter.enroll() enrollment failed"
                                    ),
                                    exception.message
                            )
                        }
                    }

            // Start the enrollment process.
            buildGuardian(forDomain).enroll(usingUri, device, keyPair).start(callback)
        } catch (exception: Exception) {
            result.error(
                    "UnexpectedError",
                    getGuardianErrorMessage("GuardianFlutter.enroll() thrown an unexpected error"),
                    exception.message
            )
        }
    }

    private fun acceptRequest(args: Map<String, Any>, result: MethodChannel.Result) {
        try {
            // Extract the arguments from the method call (Flutter).
            val payload = args["notification"] as Map<String, String>
            val forDomain = args["forDomain"] as String

            // Generate the notification object from the push payload.
            val notification: ParcelableNotification? = Guardian.parseNotification(payload)

            // Get the signing key.
            val signingKey = SigningKeyService(forDomain).getSigningKey()
            val enrollment: Enrollment = EnrolledDevice(signingKey)

            // Define the callback to handle the acceptRequest result.
            val callback =
                    object : Callback<Void> {
                        override fun onSuccess(response: Void?) {
                            result.success(true)
                        }
                        override fun onFailure(exception: Throwable) {
                            result.error(
                                    "EnrollFailure",
                                    getGuardianErrorMessage(
                                            "GuardianFlutter.acceptRequest() failed"
                                    ),
                                    exception.message
                            )
                        }
                    }

            // Start the enrollment process.
            buildGuardian(forDomain).allow(notification!!, enrollment).start(callback)
        } catch (exception: Exception) {
            result.error(
                    "UnexpectedError",
                    getGuardianErrorMessage(
                            "GuardianFlutter.acceptRequest() thrown an unexpected error"
                    ),
                    exception.message
            )
        }
    }

    private fun rejectRequest(args: Map<String, Any>, result: MethodChannel.Result) {
        try {
            // Extract the arguments from the method call (Flutter).
            val payload = args["notification"] as Map<String, String>
            val withReason = args["withReason"] as? String?
            val forDomain = args["forDomain"] as String

            // Generate the notification object from the push payload.
            val notification: ParcelableNotification? = Guardian.parseNotification(payload)

            // Get the signing key.
            val signingKey = SigningKeyService(forDomain).getSigningKey()
            val enrollment: Enrollment = EnrolledDevice(signingKey)

            // Define the callback to handle the acceptRequest result.
            val callback =
                    object : Callback<Void> {
                        override fun onSuccess(response: Void?) {
                            result.success(true)
                        }
                        override fun onFailure(exception: Throwable) {
                            result.error(
                                    "EnrollFailure",
                                    getGuardianErrorMessage(
                                            "GuardianFlutter.rejectRequest() failed"
                                    ),
                                    exception.message
                            )
                        }
                    }

            // Start the enrollment process.
            buildGuardian(forDomain).reject(notification!!, enrollment, withReason).start(callback)
        } catch (exception: Exception) {
            result.error(
                    "UnexpectedError",
                    getGuardianErrorMessage(
                            "GuardianFlutter.rejectRequest() thrown an unexpected error"
                    ),
                    exception.message
            )
        }
    }

    private fun isGuardianNotification(args: Map<String, Any>, result: MethodChannel.Result) {
        try {
            val payload = args["notification"] as Map<String, String>
            val notification: ParcelableNotification? = Guardian.parseNotification(payload)
            result.success(notification != null)
        } catch (exception: Exception) {
            result.error(
                    "UnexpectedError",
                    getGuardianErrorMessage(
                            "GuardianFlutter.isGuardianNotification() thrown an unexpected error"
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

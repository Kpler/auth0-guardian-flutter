package com.kpler.auth0_guardian_flutter

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin

class KotlinFlutterPlugin : FlutterPlugin {
    lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    lateinit var context: Context

    private var guardian: GuardianFlutter? = null

    private var device: GuardianDeviceFlutter? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        this.context = flutterPluginBinding.applicationContext
        this.guardian = GuardianFlutter(this)
        this.device = GuardianDeviceFlutter(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        guardian?.dispose()
        guardian = null
        device?.dispose()
        device = null
    }
}

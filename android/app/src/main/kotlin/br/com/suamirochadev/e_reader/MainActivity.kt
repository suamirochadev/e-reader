package br.com.suamirochadev.e_reader

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity: FlutterActivity() {
    private val CHANNEL = "my_channel"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAndroidVersion") {
                val androidVersion = getAndroidVersion()
                result.success(androidVersion)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAndroidVersion(): String {
        return Build.VERSION.RELEASE ?: "Unknown"
    }
}
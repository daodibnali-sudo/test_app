package com.daodibnali.chelnok

import android.content.Context
import android.os.PowerManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private var wakeLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "chelnok_timer/power",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "acquireRunWakeLock" -> {
                    acquireRunWakeLock()
                    result.success(null)
                }
                "releaseRunWakeLock" -> {
                    releaseRunWakeLock()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        releaseRunWakeLock()
        super.onDestroy()
    }

    private fun acquireRunWakeLock() {
        val existingWakeLock = wakeLock
        if (existingWakeLock?.isHeld == true) return

        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "Chelnok:TimerRunWakeLock",
        ).apply {
            setReferenceCounted(false)
            acquire(60 * 60 * 1000L)
        }
    }

    private fun releaseRunWakeLock() {
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
        wakeLock = null
    }
}

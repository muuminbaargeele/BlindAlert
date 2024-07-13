package com.example.blind_alert

import android.media.AudioManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.blind_alert/audio"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "stopAllAudio") {
                stopAllAudio()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun stopAllAudio() {
        val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
        audioManager.requestAudioFocus(
            { }, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN_TRANSIENT
        )
    }
}

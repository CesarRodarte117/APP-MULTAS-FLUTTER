package com.example.multas  // ⚠️ Cambia esto si tu paquete tiene otro nombre

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"  // Nombre del canal (debe coincidir con Dart)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getPackageName") {
                result.success(this.getPackageName())  // Devuelve el package name real
            } else {
                result.notImplemented()
            }
        }
    }
}
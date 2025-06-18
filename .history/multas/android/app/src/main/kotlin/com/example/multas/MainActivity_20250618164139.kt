package com.example.multas  // Asegúrate que coincida con tu package name real

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"  // Mismo nombre que en el código Dart

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Configura el canal de método para obtener el package name
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPackageName" -> {
                    try {
                        // Devuelve el package name de la aplicación
                        result.success(this.getPackageName())
                    } catch (e: Exception) {
                        result.error("ERROR", "No se pudo obtener el package name", e.toString())
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
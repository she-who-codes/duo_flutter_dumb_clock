package com.example.flutter_duo

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import io.flutter.plugin.common.MethodChannel
import com.microsoft.device.display.DisplayMask


class MainActivity: FlutterActivity() {

    private val CHANNEL = "duosdk.microsoft.dev"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(!isDualScreenDevice()) {
                result.success(false)
            } else {
                try {
                    if (call.method == "isDualScreenDevice") {
                        if (isDualScreenDevice()) {
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } else if (call.method == "isAppSpanned") {
                        if (isAppSpanned()) {
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.notImplemented()
                    }
                } catch(e: Exception){
                    result.success(false)
                }
            }
        }
    }

    fun isDualScreenDevice(): Boolean {
        val feature = "com.microsoft.device.display.displaymask"
        val pm = this.getPackageManager()
        if (pm.hasSystemFeature(feature)) {
            return true
        } else {
            return false
        }
    }

    fun isAppSpanned(): Boolean {
        var displayMask = DisplayMask.fromResourcesRectApproximation(this)
        var boundings = displayMask.getBoundingRects()
        var first = boundings.get(0)
        var rootView = this.getWindow().getDecorView().getRootView()
        var drawingRect = android.graphics.Rect()
        rootView.getDrawingRect(drawingRect)
        if (first.intersect(drawingRect)) {
            return true
        } else {
            return false
        }
    }
}

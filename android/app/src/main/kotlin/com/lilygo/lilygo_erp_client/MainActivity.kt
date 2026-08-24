package com.lilygo.lilygo_erp_client

import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.app.Presentation
import android.graphics.BitmapFactory
import android.hardware.display.DisplayManager
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.webrtc.PeerConnectionFactory

class MainActivity : FlutterActivity() {
    private val channelName = "lilygo/android_client"
    private var peerConnectionFactory: PeerConnectionFactory? = null
    private var pieceExchange: PieceExchangeEngine? = null
    private val nativeExecutor: ExecutorService = Executors.newSingleThreadExecutor()

    companion object {
        init {
            System.loadLibrary("duckdb_android")
        }
    }

    private external fun nativeDuckDbInit(path: String): Boolean
    private external fun nativeDuckDbClose()
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "initializeWebRtc") {
                    initializeWebRtc(result)
                    return@setMethodCallHandler
                }
                if (call.method == "initializePieceExchange") {
                    pieceExchange = PieceExchangeEngine()
                    result.success(true)
                    return@setMethodCallHandler
                }
                if (call.method == "pieceExchangeStatus") {
                    result.success(pieceExchange?.progress() ?: emptyMap<String, Any>())
                    return@setMethodCallHandler
                }
                if (call.method == "initializeDuckDb") {
                    nativeExecutor.execute {
                        val initialized = nativeDuckDbInit(
                            File(filesDir, "portal.duckdb").absolutePath,
                        )
                        runOnUiThread { result.success(initialized) }
                    }
                    return@setMethodCallHandler
                }
                if (call.method != "openClient") {
                    if (call.method == "showSecondDisplay") {
                        showSecondDisplay(call, result)
                    } else {
                        result.notImplemented()
                    }
                    return@setMethodCallHandler
                }
                val url = call.argument<String>("url")
                if (url.isNullOrBlank()) {
                    result.error("INVALID_URL", "Client URL is missing", null)
                    return@setMethodCallHandler
                }
                openClient(url, result)
            }
    }

    override fun onDestroy() {
        nativeDuckDbClose()
        peerConnectionFactory?.dispose()
        peerConnectionFactory = null
        pieceExchange = null
        nativeExecutor.shutdownNow()
        super.onDestroy()
    }

    private fun initializeWebRtc(result: MethodChannel.Result) {
        try {
            if (peerConnectionFactory == null) {
                PeerConnectionFactory.initialize(
                    PeerConnectionFactory.InitializationOptions.builder(this)
                        .setEnableInternalTracer(false)
                        .createInitializationOptions(),
                )
                peerConnectionFactory = PeerConnectionFactory.builder()
                    .createPeerConnectionFactory()
            }
            result.success(true)
        } catch (error: Exception) {
            result.error("WEBRTC_INIT_FAILED", error.message, null)
        }
    }

    private fun showSecondDisplay(call: MethodCall, result: MethodChannel.Result) {
        val displays = getSystemService(DisplayManager::class.java)
            .getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)
        if (displays.isEmpty()) {
            result.success(false)
            return
        }
        val qr = call.argument<ByteArray>("qr")
        val link = call.argument<String>("link") ?: ""
        val image = qr?.let { BitmapFactory.decodeByteArray(it, 0, it.size) }
        val presentation = object : Presentation(this, displays.first()) {
            override fun onCreate(state: android.os.Bundle?) {
                super.onCreate(state)
                val layout = LinearLayout(context).apply {
                    orientation = LinearLayout.VERTICAL
                    gravity = android.view.Gravity.CENTER
                    setPadding(8, 8, 8, 8)
                    setBackgroundColor(android.graphics.Color.BLACK)
                }
                if (image != null) {
                    layout.addView(ImageView(context).apply {
                        setImageBitmap(image)
                        adjustViewBounds = true
                        setBackgroundColor(android.graphics.Color.WHITE)
                    }, LinearLayout.LayoutParams(220, 220))
                }
                layout.addView(TextView(context).apply {
                    text = call.argument<String>("channel") ?: "STORE"
                    setTextColor(android.graphics.Color.WHITE)
                    textSize = 12f
                    gravity = android.view.Gravity.CENTER
                }, ViewGroup.LayoutParams(-1, -2))
                setContentView(layout)
            }
        }
        presentation.show()
        result.success(true)
    }

    private fun openClient(url: String, result: MethodChannel.Result) {
        try {
            // XBrowser on Android 7 crashes if ACTION_VIEW is its first
            // activity because its tab stack has not been initialized yet.
            // Start its launcher activity first, then hand it the URL.
            val browserPackage = "com.xbrowser.play"
            val browserLauncher = packageManager.getLaunchIntentForPackage(browserPackage)
            if (browserLauncher != null) {
                startActivity(browserLauncher)
                Handler(Looper.getMainLooper()).postDelayed({
                    startActivity(
                        Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
                            setPackage(browserPackage)
                            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                        },
                    )
                }, 700)
            } else {
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
            }
            result.success(null)
        } catch (error: Exception) {
            result.error("BROWSER_UNAVAILABLE", "No browser can open the client URL", error.message)
        }
    }
}

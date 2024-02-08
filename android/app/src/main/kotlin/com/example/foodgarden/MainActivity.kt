package com.example.foodgarden

import io.flutter.embedding.android.FlutterActivity
import android.app.PendingIntent
import android.content.Intent
import android.nfc.NfcAdapter
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private val channel = "app_settings"
    private lateinit var mResult: MethodChannel.Result

    override fun onResume() {
        super.onResume()
        val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or
                    PendingIntent.FLAG_IMMUTABLE
        )
        NfcAdapter.getDefaultAdapter(this)
            ?.enableForegroundDispatch(this, pendingIntent, null, null)
    }

    override fun onPause() {
        super.onPause()
        NfcAdapter.getDefaultAdapter(this)?.disableForegroundDispatch(this)
    }

    override fun onActivityResult(requestCode: Int, result: Int, intent: Intent?) {
        if (requestCode != 27)
            mResult.success(false)
        if (requestCode == 27) {
            mResult.success(true)
        } else
            mResult.success(false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "nfc") {
                mResult = result
                val intent = Intent("android.settings.NFC_SETTINGS")
                startActivityForResult(intent, 27)
            } else if (call.method == "isNFCSupportedDevice") {
                if (NfcAdapter.getDefaultAdapter(context) != null) {
                    result.success(true)
                } else {
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }

}

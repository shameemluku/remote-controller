package com.example.flutter_ir_app

import android.content.Context
import android.hardware.ConsumerIrManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_ir_app/ir"
    private lateinit var irManager: ConsumerIrManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        irManager = getSystemService(Context.CONSUMER_IR_SERVICE) as ConsumerIrManager
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasIrEmitter" -> {
                    result.success(irManager.hasIrEmitter())
                }
                "getCarrierFrequencies" -> {
                    if (irManager.hasIrEmitter()) {
                        val ranges = irManager.carrierFrequencies
                        val freqList = ranges?.map { 
                            mapOf("min" to it.minFrequency, "max" to it.maxFrequency) 
                        }
                        result.success(freqList)
                    } else {
                        result.success(null)
                    }
                }
                "transmit" -> {
                    val frequency = call.argument<Int>("frequency") ?: 38000
                    val pattern = call.argument<List<Int>>("pattern")
                    
                    if (pattern != null && irManager.hasIrEmitter()) {
                        try {
                            val intArray = pattern.toIntArray()
                            irManager.transmit(frequency, intArray)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("TRANSMIT_ERROR", e.message, null)
                        }
                    } else {
                        result.error("NO_IR", "Device doesn't have IR blaster", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

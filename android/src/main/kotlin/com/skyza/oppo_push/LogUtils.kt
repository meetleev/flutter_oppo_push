package com.skyza.oppo_push

import LogLevel
import android.util.Log

object LogUtils {
    const val TAG = "OppoPushPlugin"

    // Default log level
    private var currentLogLevel: LogLevel = LogLevel.DEBUG

    // Set the minimum log level for output
    @JvmStatic
    fun setLogLevel(level: LogLevel) {
        currentLogLevel = level
    }

    // Get the current log level
    @JvmStatic
    fun getLogLevel(): LogLevel = currentLogLevel

    @JvmStatic
    fun verbose(`object`: Any?) {
        if ( currentLogLevel.raw > LogLevel.VERBOSE.raw) return
        val msg: String = `object`?.toString() ?: "null"
        Log.v(TAG, msg)
    }

    @JvmStatic
    fun debug(`object`: Any?) {
        if ( currentLogLevel.raw > LogLevel.DEBUG.raw) return
        val msg: String = `object`?.toString() ?: "null"
        Log.d(TAG, msg)
    }

    @JvmStatic
    fun info(`object`: Any?) {
        if ( currentLogLevel.raw > LogLevel.INFO.raw) return
        val msg: String = `object`?.toString() ?: "null"
        Log.i(TAG, msg)
    }

    @JvmStatic
    fun warn(`object`: Any?) {
        if ( currentLogLevel.raw > LogLevel.WARN.raw) return
        val msg: String = `object`?.toString() ?: "null"
        Log.w(TAG, msg)
    }

    @JvmStatic
    fun error(`object`: Any?, error: Throwable? = null) {
        if ( currentLogLevel.raw > LogLevel.ERROR.raw) return
        val msg: String = when (`object`) {
            is Exception -> `object`.localizedMessage
            else -> `object`?.toString()
        } ?: "null"
        if (error != null) {
            Log.e(TAG, msg, error)
        } else {
            Log.e(TAG, msg)
        }
    }


}
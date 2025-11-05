package com.skyza.oppo_push

import LogLevel
import NotificationStatus
import PushInterface
import StreamEventsStreamHandler
import android.app.Application
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.heytap.msp.push.HeytapPushManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody


/** OppoPushPlugin */
class OppoPushPlugin : FlutterPlugin, PushInterface {
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var applicationContext: Context? = null
    private lateinit var pushEventListener: PushEventListener
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        applicationContext = pluginBinding?.applicationContext
        pushEventListener = PushEventListener()
        StreamEventsStreamHandler.register(flutterPluginBinding.binaryMessenger, pushEventListener)
        PushInterface.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun setLogLevel(
        level: LogLevel,
        callback: (Result<Unit>) -> Unit
    ) {
        LogUtils.setLogLevel(level)
    }

    override fun getLogLevel(callback: (Result<LogLevel>) -> Unit) {
        callback(Result.success(LogUtils.getLogLevel()))
    }

    override fun initialize(oppoLogEnabled: Boolean) {
        HeytapPushManager.init(applicationContext, oppoLogEnabled)
    }


    override fun resumePush() {
        HeytapPushManager.resumePush()
    }

    override fun pausePush() {
        HeytapPushManager.pausePush()
    }

    override fun getPushStatus() {
        HeytapPushManager.getPushStatus()
    }

    override fun setPushTime(
        weekDays: List<Long>,
        startHour: Long,
        startMin: Long,
        endHour: Long,
        endMin: Long
    ) {
        HeytapPushManager.setPushTime(
            weekDays.asSequence()
                .map { it.toInt() }
                .toList(), startHour.toInt(), startMin.toInt(), endHour.toInt(), endMin.toInt())
    }

    override fun getRegId(callback: (Result<String>) -> Unit) {
        try {
            val token = HeytapPushManager.getRegisterID()
            callback(Result.success(token))
        } catch (e: Exception) {
            e.printStackTrace()
            callback(Result.failure(e))
        }
    }


    override fun registerToken(appKey: String, appSecret: String) {
        HeytapPushManager.register(
            applicationContext,
            appKey,
            appSecret,
            pushEventListener
        )
    }

    override fun unregisterToken() {
        HeytapPushManager.unRegister()
    }

    override fun openNotificationSetting() {
        HeytapPushManager.openNotificationSettings()
    }

    override fun getNotificationStatus() {
        HeytapPushManager.getNotificationStatus()
    }

    override fun enableAppNotificationSwitch(callback: (Result<NotificationStatus>) -> Unit) {
        HeytapPushManager.enableAppNotificationSwitch { code ->
            {
                callback(
                    Result.success(
                        NotificationStatus.ofRaw(code) ?: NotificationStatus.UNKNOWN
                    )
                )
            }
        }
    }

    override fun disableAppNotificationSwitch(callback: (Result<NotificationStatus>) -> Unit) {
        HeytapPushManager.disableAppNotificationSwitch { code ->
            {
                callback(
                    Result.success(
                        NotificationStatus.ofRaw(code) ?: NotificationStatus.UNKNOWN
                    )
                )
            }
        }
    }

    // 获取应用内通知开关结果,如果成功返回0，失败返回非0，具体指参考错误码
    // appSwitch：0：未定义状态（不校验开关），1：打开状态，2：关闭状态
    override fun getAppNotificationSwitch(callback: (Result<NotificationStatus>) -> Unit) {
        HeytapPushManager.getAppNotificationSwitch { responseCode, appSwitch ->
            {
                if (0 == responseCode) {
                    if (0 == appSwitch) {
                        callback(Result.success(NotificationStatus.UNKNOWN))
                    }
                    if (1 == appSwitch) {
                        callback(Result.success(NotificationStatus.OPEN))
                    }
                    if (2 == appSwitch) {
                        callback(Result.success(NotificationStatus.CLOSE))
                    }
                } else {
                    callback(Result.success(NotificationStatus.UNKNOWN))
                }
            }
        }
    }


    override fun isSupport(callback: (Result<Boolean>) -> Unit) {
        val isSupport = HeytapPushManager.isSupportPush(applicationContext)
        callback(Result.success(isSupport))
    }
}

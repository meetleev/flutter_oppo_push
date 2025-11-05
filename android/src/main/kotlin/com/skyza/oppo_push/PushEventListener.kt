package com.skyza.oppo_push

import ErrorEvent
import NotificationStatus
import NotificationStatusEvent
import PigeonEventSink
import PlatformEvent
import PushStatus
import PushStatusEvent
import RegisterEvent
import StreamEventsStreamHandler
import UnregisterEvent
import android.os.Handler
import android.os.Looper
import com.heytap.msp.push.callback.ICallBackResultService

// 所有回调都需要根据responseCode来判断操作是否成功，0代表成功,其他代码失败，失败具体原因可以查阅附录中的错误码列表。
open class PushEventListener : ICallBackResultService, StreamEventsStreamHandler() {
    private var eventSink: PigeonEventSink<PlatformEvent>? = null

    /**
     * 注册的结果,如果注册成功,registerID就是客户端的唯一身份标识
     *
     * @param responseCode 接口执行结果码，0表示接口执行成功
     * @param registerId   注册id/token
     * @param packageName 如果当前执行注册的应用是常规应用，则通过packageName返回当前应用对应的包名
     * @param miniPackageName  如果当前是快应用进行push registerID的注冊，则通过miniPackageName进行标识快应用包名
     */
    override fun onRegister(
        responseCode: Int,
        registerId: String?,
        packageName: String?,
        miniPackageName: String?
    ) {
        LogUtils.debug("PushEventListener:onRegister => responseCode:[$responseCode], responseCode:[$responseCode], packageName:[$packageName], miniPackageName:[$miniPackageName]")
        val mainHandler = Handler(Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(
                RegisterEvent(
                    responseCode.toLong(),
                    registerId,
                    packageName,
                    miniPackageName
                )
            )
        }
    }

    /**
     * 应用注销结果回调接口，将应用请求服务端的注销接口进行结果传达
     * @param responseCode 接口执行结果码，0表示接口执行成功
     * @param packageName  当前注销的应用的包名
     * @param miniPackageName  如果是快应用注销，则会将快应用的包名一起返回给业务方(一般是快应用中心，由快应用中心进行分发)
     */
    override fun onUnRegister(responseCode: Int, packageName: String?, miniPackageName: String?) {
        LogUtils.debug("PushEventListener:onUnRegister => responseCode:[$responseCode], packageName:[$packageName], miniPackageName:[$miniPackageName]")
        val mainHandler = Handler(Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(UnregisterEvent(responseCode.toLong(), packageName, miniPackageName))
        }
    }

    // 获取设置推送时间的执行结果
    override fun onSetPushTime(responseCode: Int, pushTime: String?) {
        LogUtils.debug("PushEventListener:onSetPushTime => responseCode:[$responseCode], pushTime:[$pushTime]")
        val mainHandler = Handler(Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(UnregisterEvent(responseCode.toLong(), pushTime))
        }
    }

    // 获取当前的push状态返回,根据返回码判断当前的push状态,返回码具体含义可以参考[错误码]
    override fun onGetPushStatus(responseCode: Int, status: Int) {
        LogUtils.debug("PushEventListener:onGetPushStatus => responseCode:[$responseCode], pushTime:[$status]")
        val mainHandler = Handler(Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(
                PushStatusEvent(
                    responseCode.toLong(),
                    PushStatus.ofRaw(status) ?: PushStatus.UNKNOWN
                )
            )
        }
    }

    override fun onGetNotificationStatus(responseCode: Int, status: Int) {
        LogUtils.debug("PushEventListener:onGetNotificationStatus => responseCode:[$responseCode], pushTime:[$status]")
        val mainHandler = Handler(Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(
                NotificationStatusEvent(
                    responseCode.toLong(),
                    NotificationStatus.ofRaw(status) ?: NotificationStatus.UNKNOWN
                )
            )
        }
    }

    /** 异常处理的回调
     * @param errorCode   错误码
     * @param message     错误信息
     * @param packageName 当前注册失败的应用包名，如果是应用注册，则返回应用注册包名，如果是为快应用做接口请求，则这里返回的是快应用中心的包名
     * @param miniProgramPkg 当前注册失败的快应用包名
     */
    override fun onError(
        errorCode: Int,
        message: String,
        packageName: String,
        miniProgramPkg: String
    ) {
        LogUtils.warn("PushEventListener:onError => errorCode:[$errorCode], message:[$message], packageName:[$packageName], miniProgramPkg:[$miniProgramPkg]")
        val mainHandler = Handler(Looper.getMainLooper())
        mainHandler.post {
            eventSink?.success(ErrorEvent(errorCode.toLong(), message, packageName, miniProgramPkg))
        }
    }


    override fun onListen(p0: Any?, sink: PigeonEventSink<PlatformEvent>) {
        eventSink = sink
    }

    fun onEventsDone() {
        eventSink?.endOfStream()
        eventSink = null
    }
}

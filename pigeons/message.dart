import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/src/main/kotlin/com/skyza/oppo_push/Messages.g.kt',
  kotlinOptions: KotlinOptions(),
  copyrightHeader: 'pigeons/copyright.txt',
  dartPackageName: 'oppo_push',
))
enum LogLevel { verbose, debug, info, warn, error, off }

enum PushStatus { start, pause, stop, unknown }

enum NotificationStatus { open, close, unknown }

@HostApi()
abstract class PushInterface {
  @async
  void setLogLevel(LogLevel level);
  @async
  LogLevel getLogLevel();

  /// 初始化push服务
  void initialize(bool oppoLogEnabled);

  /// 恢复接收MSP服务推送的消息，这时服务器会把暂停时期的推送消息重新推送过来
  void resumePush();

  /// 暂停接收MSP服务推送的消息
  void pausePush();

  /// 获取MSP推送服务状态
  void getPushStatus();

  /// 设置允许推送时间 API,  weekDays 周日为0,周一为1,以此类推, startHour 开始时间,24小时制, endHour 结束时间,24小时制
  void setPushTime(
      {required List<int> weekDays,
      required int startHour,
      required int startMin,
      required int endHour,
      required int endMin});

  /// 获取当前设备的当前应用的唯一标识，后台可基于此标识发送通知
  @async
  String getRegId();

  /// 注册push，获取申请的regId
  void registerToken({required String appKey, required String appSecret});

  /// 解注册push，关闭push功能
  void unregisterToken();

  /// 打开通知栏设置界面
  void openNotificationSetting();

  /// 获取通知栏状态
  void getNotificationStatus();

  /// 打开应用内通知
  @async
  NotificationStatus enableAppNotificationSwitch();

  /// 关闭应用内通知
  @async
  NotificationStatus disableAppNotificationSwitch();

  /// 获取应用内通知开关
  @async
  NotificationStatus getAppNotificationSwitch();

  /// 用于判断当前系统是否支持push服务
  @async
  bool isSupport();
}

sealed class PlatformEvent {}

class SetPushTimeEvent extends PlatformEvent {
  final String? pushTime;
  final int responseCode;

  SetPushTimeEvent({required this.responseCode, this.pushTime});
}

class PushStatusEvent extends PlatformEvent {
  final int responseCode;

  final PushStatus status;

  PushStatusEvent({required this.responseCode, required this.status});
}

class NotificationStatusEvent extends PlatformEvent {
  final int responseCode;

  final NotificationStatus status;

  NotificationStatusEvent({required this.responseCode, required this.status});
}

class RegisterEvent extends PlatformEvent {
  final int responseCode;

  /// 注册id/token
  final String? token;

  /// 当前注册失败的应用包名，如果是应用注册，则返回应用注册包名，如果是为快应用做接口请求，则这里返回的是快应用中心的包名
  final String? packageName;

  /// 当前注册失败的快应用包名
  final String? miniProgramPkg;

  RegisterEvent(
      {required this.responseCode,
      this.token,
      this.packageName,
      this.miniProgramPkg});
}

class UnregisterEvent extends PlatformEvent {
  final int responseCode;

  /// 当前注册失败的应用包名，如果是应用注册，则返回应用注册包名，如果是为快应用做接口请求，则这里返回的是快应用中心的包名
  final String? packageName;

  /// 当前注册失败的快应用包名
  final String? miniProgramPkg;

  UnregisterEvent(
      {required this.responseCode, this.packageName, this.miniProgramPkg});
}

/// 异常处理的回调
class ErrorEvent extends PlatformEvent {
  final int code;

  /// 错误信息
  final String message;

  /// 当前注册失败的应用包名，如果是应用注册，则返回应用注册包名，如果是为快应用做接口请求，则这里返回的是快应用中心的包名
  final String packageName;

  /// 当前注册失败的快应用包名
  final String miniProgramPkg;

  ErrorEvent(
      {required this.code,
      required this.message,
      required this.packageName,
      required this.miniProgramPkg});
}

/// 所有回调都需要根据responseCode来判断操作是否成功，0代表成功,其他代码失败，失败具体原因可以查阅附录中的错误码列表, https://open.oppomobile.com/documentation/page/info?id=11224
@EventChannelApi()
abstract class PushCallBackEventChannel {
  PlatformEvent streamEvents();
}

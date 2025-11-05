import 'package:oppo_push/src/messages.g.dart';

export 'src/messages.g.dart'
    show
        PlatformEvent,
        SetPushTimeEvent,
        PushStatusEvent,
        NotificationStatusEvent,
        RegisterEvent,
        UnregisterEvent,
        ErrorEvent;

class OppoPush {
  final PushInterface _pushInterface = PushInterface();

  factory OppoPush() => instance;

  static OppoPush get instance => OppoPush._();
  OppoPush._();

  Stream<PlatformEvent> get pushStream => streamEvents();

  Future<void> setLogLevel(LogLevel level) => _pushInterface.setLogLevel(level);
  Future<LogLevel> getLogLevel() => _pushInterface.getLogLevel();

  /// 初始化push服务
  Future<void> initialize([bool oppoLogEnabled = false]) =>
      _pushInterface.initialize(oppoLogEnabled);

  /// 恢复接收MSP服务推送的消息，这时服务器会把暂停时期的推送消息重新推送过来
  Future<void> resumePush() => _pushInterface.resumePush();

  /// 暂停接收MSP服务推送的消息
  Future<void> pausePush() => _pushInterface.pausePush();

  /// 获取当前设备的当前应用的唯一标识，后台可基于此标识发送通知
  Future<String> getRegId() => _pushInterface.getRegId();

  /// 获取MSP推送服务状态
  Future<void> getPushStatus() => _pushInterface.getPushStatus();

  /// 获取MSP推送服务状态
  Future<void> setPushTime(
          {required List<int> weekDays,
          required int startHour,
          int startMin = 0,
          required int endHour,
          int endMin = 0}) =>
      _pushInterface.setPushTime(
          weekDays: weekDays,
          startHour: startHour,
          startMin: startMin,
          endHour: endHour,
          endMin: endMin);

  /// 注册push，获取申请的regId
  Future<void> registerToken(
          {required String appKey, required String appSecret}) =>
      _pushInterface.registerToken(appKey: appKey, appSecret: appSecret);

  /// 解注册push，关闭push功能
  Future<void> unregisterToken() => _pushInterface.unregisterToken();

  /// 用于判断当前系统是否支持push服务
  Future<bool> isSupport() => _pushInterface.isSupport();

  /// 打开通知栏设置界面
  Future<void> openNotificationSetting() =>
      _pushInterface.openNotificationSetting();

  /// 获取通知栏状态
  Future<void> getNotificationStatus() =>
      _pushInterface.getNotificationStatus();

  /// 打开应用内通知
  Future<NotificationStatus> enableAppNotificationSwitch() =>
      _pushInterface.enableAppNotificationSwitch();

  /// 关闭应用内通知
  Future<NotificationStatus> disableAppNotificationSwitch() =>
      _pushInterface.disableAppNotificationSwitch();

  /// 获取应用内通知开关
  Future<NotificationStatus> getAppNotificationSwitch() =>
      _pushInterface.getAppNotificationSwitch();
}

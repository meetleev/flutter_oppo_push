import 'dart:async';

import 'package:flutter/material.dart';

import 'package:oppo_push/oppo_push.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _pushPlugin = OppoPush();
  final appKey = "";
  final appSecret = "";

  late StreamSubscription<PlatformEvent> _pushEventStreamSubscription;
  String _msg = '', _eventMsg = '';

  @override
  void initState() {
    _pushPlugin.initialize(true);
    _pushEventStreamSubscription = _pushPlugin.pushStream.listen(onPushEvent);
    super.initState();
  }

  void onPushEvent(PlatformEvent event) {
    if (mounted) {
      if (event is SetPushTimeEvent) {
        setState(() {
          _eventMsg =
              'SetPushTimeEvent=> responseCode:[${event.responseCode}], pushTime:[${event.pushTime}]';
        });
      }

      if (event is RegisterEvent) {
        setState(() {
          _eventMsg =
              'RegisterEvent=> responseCode:[${event.responseCode}], token:[${event.token}], packageName:[${event.packageName}], miniProgramPkg:[${event.miniProgramPkg}]';
        });
      }

      if (event is UnregisterEvent) {
        setState(() {
          _eventMsg =
              'UnregisterEvent=> responseCode:[${event.responseCode}], packageName:[${event.packageName}], miniProgramPkg:[${event.miniProgramPkg}]';
        });
      }

      if (event is PushStatusEvent) {
        setState(() {
          _eventMsg =
              'PushStatusEvent=> responseCode:[${event.responseCode}], status:[${event.status}]';
        });
      }

      if (event is NotificationStatusEvent) {
        setState(() {
          _eventMsg =
              'NotificationStatusEvent=> responseCode:[${event.responseCode}], status:[${event.status}]';
        });
      }
      if (event is ErrorEvent) {
        setState(() {
          _eventMsg =
              'ErrorEvent=> code:[${event.code}], message:[${event.message}], packageName:[${event.packageName}], miniProgramPkg:[${event.miniProgramPkg}]';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('oppo_push_example'),
        ),
        body: ListView(
          children: [
            Text(_msg),
            Text(_eventMsg),
            TextButton(
                onPressed: () {
                  _pushPlugin.resumePush();
                },
                child: Text('resumePush')),
            TextButton(
                onPressed: () {
                  _pushPlugin.pausePush();
                },
                child: Text('pausePush')),
            TextButton(
                onPressed: () {
                  _pushPlugin.registerToken(
                      appKey: appKey, appSecret: appSecret);
                },
                child: Text('registerToken')),
            TextButton(
                onPressed: () {
                  _pushPlugin.unregisterToken();
                },
                child: Text('unregisterToken')),
            TextButton(
                onPressed: () async {
                  final token = await _pushPlugin.getRegId();
                  if (mounted) {
                    setState(() {
                      _msg = 'token:$token';
                    });
                  }
                },
                child: Text('getRegId')),
            TextButton(
                onPressed: () async {
                  final isSupport = await _pushPlugin.isSupport();
                  if (mounted) {
                    setState(() {
                      _msg = 'isSupportPush:$isSupport';
                    });
                  }
                },
                child: Text('isSupportPush')),
            TextButton(
                onPressed: () {
                  _pushPlugin.openNotificationSetting();
                },
                child: Text('openNotificationSetting')),
            TextButton(
                onPressed: () {
                  _pushPlugin.getNotificationStatus();
                },
                child: Text('getNotificationStatus')),
            TextButton(
                onPressed: () async {
                  final notificationStatus =
                      await _pushPlugin.enableAppNotificationSwitch();
                  if (mounted) {
                    setState(() {
                      _msg = 'notificationStatus:$notificationStatus';
                    });
                  }
                },
                child: Text('enableAppNotificationSwitch')),
            TextButton(
                onPressed: () async {
                  final notificationStatus =
                      await _pushPlugin.disableAppNotificationSwitch();
                  if (mounted) {
                    setState(() {
                      _msg = 'notificationStatus:$notificationStatus';
                    });
                  }
                },
                child: Text('disableAppNotificationSwitch')),
            TextButton(
                onPressed: () async {
                  final notificationStatus =
                      await _pushPlugin.getAppNotificationSwitch();
                  if (mounted) {
                    setState(() {
                      _msg = 'notificationStatus:$notificationStatus';
                    });
                  }
                },
                child: Text('getAppNotificationSwitch')),
            TextButton(
                onPressed: () {
                  _pushPlugin.getPushStatus();
                },
                child: Text('getPushStatus')),
            TextButton(
                onPressed: () {
                  _pushPlugin.setPushTime(
                      weekDays: [1, 2],
                      startHour: 1,
                      startMin: 0,
                      endHour: 23,
                      endMin: 0);
                },
                child: Text('getPushStatus')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pushEventStreamSubscription.cancel();
    super.dispose();
  }
}

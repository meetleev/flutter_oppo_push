# oppo_push

[![Pub](https://img.shields.io/pub/v/oppo_push.svg?style=flat-square)](https://pub.dev/packages/oppo_push)
[![support](https://img.shields.io/badge/platform-android%20-blue.svg)](https://pub.dev/packages/oppo_push)

oppo 推送API (vpush)

一个轻量级 Flutter 插件，用于集成 oppo 推送 API。它简化了 oppo 手机平台的推送通知开发，支持 token 注册、消息接收和回调处理。

## Usage

``` dart
    import 'package:oppo_push/oppo_push.dart';

    final oppoPushPlugin = OppoPush();
    await oppoPushPlugin.initialize(false);
    oppoPushPlugin.pushStream.listen(onPushEvent);
    await oppoPushPlugin.registerToken(
                            appKey: 'appKey',
                            appSecret: 'appSecret');
    final regId = resp.token;


    void onPushEvent(PlatformEvent event) {
        if (event is RegisterEvent) {
          String eventMsg =
              'RegisterEvent=> responseCode:[${event.responseCode}], token:[${event.token}], packageName:[${event.packageName}], miniProgramPkg:[${event.miniProgramPkg}]';
        };
      }
    

```
[example](./example/lib/main.dart)

## Additional information

具体参考:[oppo客户端API接口文档](https://dev.oppo.com.cn/documentCenter/doc/364)

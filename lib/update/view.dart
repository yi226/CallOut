import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var url = 'https://github.com/yi226/CallOut/releases/download/v2.0.2/update.json';
  var _message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('当前版本: 2.0.2'),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('在线更新'),
              onPressed: () {
                FlutterXUpdate.checkUpdate(
                  url: url,
                  themeColor: '#87FA875D',
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('后台更新'),
              onPressed: () {
                FlutterXUpdate.checkUpdate(
                  url: url,
                  supportBackgroundUpdate: true
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initXUpdate();
  }

  //初始化XUpdate
  void initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(
        //是否输出日志
        debug: true,
        //是否使用post请求
        isPost: false,
        //post请求是否是上传json
        isPostJson: false,
        //请求响应超时时间
        timeout: 4000,
        //是否开启自动模式
        isWifiOnly: false,
        //是否开启自动模式
        isAutoMode: false,
        //需要设置的公共参数
        supportSilentInstall: false,
        //在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
        enableRetry: false)
        .then((value) {
          print("初始化成功: $value");
        }).catchError((error) {
        print(error);
      });
      
      FlutterXUpdate.setErrorHandler(
        onUpdateError: (Map<String, dynamic>? message) async {
          setState((){
            _message = message!["message"];
          });
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(''),
                content: Text(_message),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("确定"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
        });
    } else {
      debugPrint("ios暂不支持XUpdate更新");
    }
  }
}



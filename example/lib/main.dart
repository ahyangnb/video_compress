import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _chargingStatus = 'Unknown';

//  static const EventChannel eventChannel =
//  const EventChannel('samples.flutter.io/charging');

  @override
  void initState() {
    super.initState();
    initPlatformState();
//    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

//  void _onEvent(Object event) {
//    setState(() {
//      _chargingStatus =
//      "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
//    });
//  }
//
//  void _onError(Object error) {
//    setState(() {
//      _chargingStatus = 'Battery status: unknown.';
//    });
//  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await VideoCompress.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _chargingStatus = platformVersion;
    });
  }

  selectVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;
    String result = await VideoCompress.videoCompress(video.path);
    print('压缩结果::$result');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => selectVideo(),
              child: new Text('选择'),
            )
          ],
        ),
        body: Center(
          child: Text('Running on: $_chargingStatus\n'),
        ),
      ),
    );
  }
}

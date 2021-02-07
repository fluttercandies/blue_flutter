import 'package:blue_flutter_example/pages/connect_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:blue_flutter/blue_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deviceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName ?? 'blue_flutter'),
        actions: [
          FlatButton(
            minWidth: 40,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ConnectPage();
              }));
            },
            child: Text(
              '选择连接',
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            minWidth: 40,
            padding: EdgeInsets.symmetric(horizontal: 0),
            onPressed: () => more(),
            child: Icon(CupertinoIcons.ellipsis, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Text('蓝牙插件'),
      ),
    );
  }

  void more() {
    var position = RelativeRect.fromLTRB(MediaQuery.of(context).size.width,
        MediaQuery.of(context).padding.top, 0, 0);
    showMenu(
      context: context,
      position: position,
      items: ['test'].map((e) {
        return PopupMenuItem(child: Text(e), value: e);
      }).toList(),
    ).then((value) {
      if (value == null) {
        return;
      }
      switch (value) {
        case 'test':
          BlueFlutter.showToast();
          break;
      }
    });
  }
}

import 'package:blue_flutter_example/pages/connect_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  bool isOpenBlue = false;
  bool isPermission = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    BlueFlutter.permission().then((value) async {
      print('是否有权限::$value');
      isPermission = value;
      if (isPermission) {
        isOpenBlue = await BlueFlutter.isOpenBlue();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var body;
    if (!isPermission) {
      body = Center(child: Text('请授权位置权限'));
    } else if (!isOpenBlue) {
      body = Center(child: Text('暂未打开蓝牙'));
    } else {
      body = Center(child: Text('蓝牙插件'));
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => init(),
        label: Icon(CupertinoIcons.refresh),
      ),
      appBar: AppBar(
        title: Text(deviceName ?? 'blue_flutter'),
        actions: [
          CupertinoSwitch(value: isOpenBlue, onChanged: (bool v) => change(v)),
          FlatButton(
            minWidth: 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            onPressed: () => more(),
            child: Icon(CupertinoIcons.ellipsis, color: Colors.white),
          ),
        ],
      ),
      body: body,
    );
  }

  void change(bool v) async {
    if (v) {
      isOpenBlue = await BlueFlutter.openBlue();
    } else {
      isOpenBlue = !(await BlueFlutter.closeBlue());
    }
    setState(() {});
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

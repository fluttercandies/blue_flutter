import 'package:flutter/material.dart';

class ConnectPage extends StatefulWidget {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择连接'),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: [
              Text('Name'),
              SizedBox(width: 10),
              Text('Id'),
            ],
          ),
        );
      }),
    );
  }
}

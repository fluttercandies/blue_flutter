import 'package:blue_flutter/blue_flutter.dart';
import 'package:flutter/material.dart';

class ConnectPage extends StatefulWidget {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  List<BondedDeviceModel> bonded = [];
  List<BondedDeviceModel> others = [];

  bool bondedExtended = true;
  bool othersExtended = false;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    BlueFlutter.getBondedDevices().then((value) {
      bonded = value;
    }).whenComplete(() {
      _isLoading = false;
      setState(() {});
    });
  }

  Widget itemBuild(e, int index) {
    BondedDeviceModel model = e;
    return Container(
      decoration: BoxDecoration(border: Border()),
      child: ListTile(
        title: Text(model.name),
        subtitle: Text(model.address),
        onTap: () => Navigator.of(context).pop(index),
      ),
    );
  }

  Widget listItem(index, okData) {
    Map itemMap = okData[index];
    String title = itemMap['title'];
    return ExpansionPanelList(
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(title: Text(title));
          },
          body: ListBody(
            children: List.generate(itemMap['data'].length, (index) {
              return itemBuild(itemMap['data'][index], index);
            }),
          ),
          isExpanded: itemMap['isExtended'],
          canTapOnHeader: true,
        ),
      ],
      expansionCallback: (panelIndex, isExpanded) {
        if (title == '已配对') {
          bondedExtended = !isExpanded;
        } else {
          othersExtended = !isExpanded;
        }
        setState(() {});
      },
      animationDuration: kThemeAnimationDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    List okData = [
      {'title': '已配对', 'data': bonded, 'isExtended': bondedExtended},
      {'title': '其他', 'data': others, 'isExtended': othersExtended},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('选择连接')),
      body: _isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: okData.length,
              itemBuilder: (context, index) {
                return listItem(index, okData);
              },
            ),
    );
  }
}

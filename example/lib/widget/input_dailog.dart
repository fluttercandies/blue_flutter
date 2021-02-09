import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 间隔组件
class Space extends StatelessWidget {
  final double width;
  final double height;

  Space({this.width = 10.0, this.height = 10.0, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(width: width, height: height);
  }
}

/// 屏幕宽度
double winWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// 键盘高度
/// 如果为0则是键盘未弹出
double winKeyHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

/// 字符串不为空
bool strNoEmpty(String value) {
  if (value == null) return false;

  return value.trim().isNotEmpty;
}

Future inputDialog(
  context, {
  final String title,
  final String tips,
  final String initText,
  final String hintText,
  final int maxLength,
  final TextInputType keyboardType,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return new InputDialogPage(
          title, tips, hintText, maxLength, initText, keyboardType);
    },
  );
}

class InputDialogPage extends StatefulWidget {
  final String title;
  final String tips;
  final String hintText;
  final String initText;
  final int maxLength;
  final TextInputType keyboardType;

  InputDialogPage(
    this.title,
    this.tips,
    this.hintText,
    this.maxLength,
    this.initText,
    this.keyboardType,
  );

  @override
  _InputDialogPageState createState() => _InputDialogPageState();
}

class _InputDialogPageState extends State<InputDialogPage> {
  TextStyle style = new TextStyle(color: Color(0xff121212), fontSize: 16);

  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController(text: widget.initText);
  }

  @override
  Widget build(BuildContext context) {
    int _maxLength = widget.maxLength ?? 10;
    return new Material(
      type: MaterialType.transparency,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            margin: EdgeInsets.only(bottom: winKeyHeight(context)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 24),
            width: winWidth(context) - 60,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  widget.title ?? '起一个好听的名字吧～',
                  style: TextStyle(
                    color: Color(0xff121212),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                new Text(
                  widget.tips ?? '30天内只能修改一次',
                  style: TextStyle(color: Color(0xff909090), fontSize: 14),
                ),
                new Space(height: 20),
                new Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F4),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: new TextField(
                    controller: controller,
                    keyboardType: widget.keyboardType,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                      hintText: widget.hintText ?? '输入昵称',
                    ),
                  ),
                ),
                new Space(height: 5),
                new Align(
                  alignment: Alignment.centerRight,
                  child: new Text(
                    '${controller.text.length}/$_maxLength',
                    style: TextStyle(
                        color: controller.text.length > _maxLength
                            ? Colors.red
                            : Color(0xff909090),
                        fontSize: 14),
                  ),
                ),
                new Space(height: 20),
                new Row(
                  children: [
                    new CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: new Text('取消'),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Color(0xffAEAEAE),
                    ),
                    new Space(width: 20),
                    new CupertinoButton(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: new Text(' 确定'),
                      onPressed: () => handle(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handle() {
    if (!strNoEmpty(controller.text)) {
      showToast('输入不能为空哦');
      return;
    } else if (controller.text.length > 999) {
      showToast('输入过长，请缩减后再试');
      return;
    }
    Navigator.of(context).pop(controller.text);
  }
}

bool _canShow = true;

///全局 弹框提示
void showToast(String text, [bool isTop = false]) async {
  if (!_canShow) {
    return;
  }
  Fluttertoast.showToast(
    msg: text ?? '未知错误',
    toastLength: Toast.LENGTH_SHORT,
    gravity: isTop ? ToastGravity.TOP : ToastGravity.CENTER,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 12,
  ).then((value) {
    _canShow = false;
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      _canShow = true;
    });
  });
}

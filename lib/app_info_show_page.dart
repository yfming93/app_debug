import 'package:app_debug/app_debug.dart';
import 'package:flutter/material.dart';

/// 接口 api host 选择界面。
class AppInfoShowPage extends StatefulWidget {
  AppInfoShowPage();
  _AppInfoShowPageState createState() => _AppInfoShowPageState();
}

class _AppInfoShowPageState extends State<AppInfoShowPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext ctx) {
    List arr = [];
    arr.addAll(AppDebug.instance.apiList);
    arr.insert(0, "选择接口环境");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "版本环境",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return _listItem(context, index, arr[index].toString());
          },
          itemCount: arr.length,
        ),
      ),
    );
  }

  Widget _listItem(BuildContext ctx, int index, String text) {
    int num = 100 * (index % 7);
    bool isApi = false;
    if (text == AppDebug.instance.apiSelected) {
      isApi = true;
    }
    return GestureDetector(
      onTap: () {
        if (index > 0) {
          if (AppDebug.instance.apiSelectedCallback != null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('提示'),
                    content: Text('您确定要切换接口环境吗？切换后可能需要重新登录！'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('确认'),
                        onPressed: () {
                          AppDebug.instance.apiSelectedCallback(text);
                          AppDebug.instance.apiSelected = text;
                          AppDebug.snackBar(ctx, text, title: "环境接切换为\n");

                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          }
        }
      },
      child: Container(
        color: Colors.blue[num],
        child: ListTile(
          trailing: isApi ? Text("当前环境") : Text(""),
          title: RichText(
            text: TextSpan(
              text: text,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

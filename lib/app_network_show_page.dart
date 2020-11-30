import 'dart:ui';
import 'package:app_debug/app_debug.dart';
import 'package:flutter/material.dart';

/// 接口网络请求展示界面
class AppNetworkShowPage extends StatefulWidget {
  @override
  AppNetworkShowPage();

  @override
  _AppNetworkShowPageState createState() => _AppNetworkShowPageState();
}

class _AppNetworkShowPageState extends State<AppNetworkShowPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "接口打印",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            int num = 100 * (index % 5);
            String textShow = AppDebug.instance.data[index] ?? "";
            return Container(
              color: Colors.blue[num],
              child: GestureDetector(
                onTap: () {
                  AppDebug.snackBar(context, textShow, autoCopy: true);
                },
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      text: textShow,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: AppDebug.instance.data.length,
        ),
      ),
    );
  }
}

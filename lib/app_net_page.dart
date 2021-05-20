import 'dart:ui';
import 'package:app_debug/app_debug.dart';
import 'package:flutter/material.dart';

/// 接口网络请求展示界面
class AppNetPage extends StatefulWidget {
  @override
  AppNetPage();

  @override
  _AppNetPageState createState() => _AppNetPageState();
}

class _AppNetPageState extends State<AppNetPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Debug Log",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell (
            onTap: (){

              AppDebug.showDebugDialog(context,'你确定要清除吗？',(){
                AppDebug.instance.data.clear();
                setState(() {

                });
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
                child:Chip(
                  label: Text("清除", style: TextStyle(fontSize: 15.0,
                    color: Color(0xff333333),),),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                )
            ),
          )

        ],
      ),
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            int num = 100 * (index % 5);
            String textShow = AppDebug.instance.data[index] ?? "";
            return Container(
              color: Colors.white,
              child: ListTile(
                title: SelectableText.rich(TextSpan(
                  text: textShow,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                )),
                trailing: InkWell (
                  onTap: (){
                    AppDebug.snackBar(context, textShow, autoCopy: true);
                  },
                  child: Icon(Icons.copy),
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


import 'dart:math' as math;
import 'package:app_debug/app_info_show_page.dart';
import 'package:app_debug/app_network_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 应用全局悬浮框
class AppFloatBox extends StatefulWidget {
  final bool showAnimation; //是否显示呼吸动画
  AppFloatBox(this.showAnimation);

  _AppFloatBoxState createState() => _AppFloatBoxState();
}

class _AppFloatBoxState extends State<AppFloatBox>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isShowDebugEntrance = true; //是否显示调试入口

  double _width;
  double _height;
  double kWidth = 55;
  double kGap = 0;
  double _kSize = 55;
  Offset offset = Offset(55 / 2, kToolbarHeight + 100);

  @override
  void initState() {
    super.initState();
    kGap = kWidth;
    if (widget.showAnimation) {
      _controller =
          AnimationController(duration: Duration(seconds: 2), vsync: this)
            ..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Offset _calOffset(Size size, Offset offset, Offset nextOffset) {
    _width = kGap;
    _height = kGap;
    double dx = kGap;
    if (offset.dx + nextOffset.dx <= kGap / 2) {
      dx = kGap / 2;
//      print("dx0:$dx");
    } else if (offset.dx + nextOffset.dx + _width >= size.width - kGap / 2) {
      dx = size.width - _width - kGap / 2;
//      print("dx1:$dx");
    } else {
      dx = offset.dx + nextOffset.dx;
//      print("dx2:$dx");
    }
    double dy = kGap;
    if (offset.dy + nextOffset.dy <= kGap) {
//      print("dy1:$dy");
      dy = kGap;
    } else if (offset.dy + nextOffset.dy + _height >= size.height - kGap / 2) {
      dy = size.height - _height - kGap / 2;
//      print("dy0:$dy");

    } else {
      dy = offset.dy + nextOffset.dy;
//      print("dy2:$dy");
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
//    final Animation opacityAnimation = Tween(begin:0.0,end: 0.8).animate(_controller);//第一种写法
//    final Animation containerAnimation = Tween(begin: 200.0,end: 400.0).animate(_controller);

    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        appBarTheme: AppBarTheme.of(context).copyWith(
          brightness: Brightness.dark,
        ),
      ),
      child: Container(
        child: Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: (detail) {
              setState(() {
                offset = _calOffset(
                    MediaQuery.of(context).size, offset, detail.delta);
              });
            },
            onTap: () {
              setState(() {
                kGap = 0;
              });
              _show(context);
            },
            onPanEnd: (detail) {},
            child: widget.showAnimation
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return _floatBox();
                    })
                : _floatBox(),
          ),
        ),
      ),
    );
  }

  Widget _floatBox() {
    return Container(
      height: isShowDebugEntrance ? _kSize : 0,
      width: isShowDebugEntrance ? _kSize : 0,
      decoration: widget.showAnimation
          ? BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  //主要代码
                  colors: [Colors.blue[600], Colors.blue[100]],
                  stops: [_controller.value, _controller.value + 0.1]))
          : BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple,
            ),
      child: Icon(
        Icons.bug_report,
        color: isShowDebugEntrance ? Colors.white : Colors.transparent,
        size: 32,
      ),
    );
  }

  void _show(BuildContext context) {
    setState(() {
      isShowDebugEntrance = false;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 400,
            color: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _items(Icons.network_check, "接口打印", AppNetworkShowPage()),
                    _items(Icons.accessibility, "版本环境", AppInfoShowPage()),
                  ],
                ),
                Container(
                  child: Transform.rotate(
                    angle: math.pi / 2,
                    child: Icon(
                      Icons.brightness_3_rounded, //brightness_3_rounded
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container()
              ],
            ),
          ),
        );
      },
    ).then((val) {
      if (val != 1) {
        _reload();
      }
    });
  }

  Widget _items(IconData icon, String name, Widget page) {
    return Container(
      child: ClipOval(
        child: InkWell(
          onTap: () {
            Navigator.pop(context, 1);
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return page;
            })).then((value) {
              _reload();
            });
          },
          child: Container(
            width: 120,
            height: 120,
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(),
                Icon(
                  icon,
                  size: 45,
                  color: Colors.white,
                ),
                Text(name),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _reload() {
    setState(() {
      kGap = kWidth;
      isShowDebugEntrance = true;
    });
  }
}

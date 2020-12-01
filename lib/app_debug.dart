library app_debug;

import 'dart:convert';
import 'package:app_debug/app_float_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDebug {
  /// 最大点击次数
  static int maxClickTimes = 15; //最大点击次数
  /// 是否打开调试工具
  static bool isOpenDebug = false;

  /// 记录当前点击次数
  static int timesClick = 0;
  /// entry
  static OverlayEntry entry;
  static const String STORAGE_KEY = "openAppDebug";

  /// 数据源
  List data = [];

  /// api host list
  List apiList = [];

  /// the api selected
  String apiSelected;

  /// 选中的 api 回调
  Function(String api) apiSelectedCallback;

  factory AppDebug() => _getInstance();
  static AppDebug get instance => _getInstance();
  static AppDebug _instance;
  AppDebug._internal() {
    //
  }
  static AppDebug _getInstance() {
    if (_instance == null) {
      _instance = AppDebug._internal();
    }
    return _instance;
  }

  /// 调试工具入口方法。
  /// [isManuel] 手动配置参数。默认 false 。在多次点击开启或者关闭工具时候需要配置 为 true 。配置好后在主页调用时候不需要传该参数。
  /// [showAnimation] 是否显示呼吸动画，默认 true 。
  static void showDebugTool(BuildContext context,
      {bool isManuel = false, bool showAnimation = true}) async {
    if (isManuel == false) {
      await getConfig();
      if (isOpenDebug == true) {
        _overlayEntry(context, showAnimation: showAnimation ?? true);
        return;
      }
    }

    timesClick++;
    if (timesClick < maxClickTimes) {
      return;
    } else {
      timesClick = 0;
      isOpenDebug = !isOpenDebug;
      await saveConfig();
    }
    _overlayEntry(context);
  }

  static _overlayEntry(BuildContext context, {bool showAnimation}) async {
    entry?.remove();
    entry = null;
    if (!isOpenDebug) {
      isOpenDebug = false;
      await saveConfig();
      return;
    }
    entry = OverlayEntry(builder: (context) {
      return AppFloatBox(showAnimation ?? true);
    });
    Overlay.of(context).insert(entry);
  }

  ///  Toast show  a text
  ///  [title] 标题
  ///  [autoCopy] 是否自动复制，默认 false 。
  static void snackBar(BuildContext ctx, String text,
      {String title = "", bool autoCopy = false}) {
    if (autoCopy) Clipboard.setData(ClipboardData(text: text));
    Scaffold.of(ctx).showSnackBar(SnackBar(
      content: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              autoCopy
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.copy_rounded,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Copied',
                  style: TextStyle(color: Colors.red, fontSize: 22),
                ),
              ])
                  : Text(title),
              Text(text)
            ],
          ),
        )
        ,
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  /// 保存配置信息
  static Future saveConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(STORAGE_KEY, isOpenDebug);
  }

  ///  获取配置信息
  static Future getConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool s = sharedPreferences.getBool(STORAGE_KEY);
    isOpenDebug = s ?? false;
  }

  /// [object]  解析的对象
  /// [deep]  递归的深度，用来获取缩进的空白长度
  /// [isObject] 用来区分当前map或list是不是来自某个字段，则不用显示缩进。单纯的map或list需要添加缩进
  static String convert(dynamic object, int deep, {bool isObject = false}) {
    var buffer = StringBuffer();
    var nextDeep = deep + 1;
    if (object is Map) {
      var list = object.keys.toList();
      if (!isObject) {
        //如果map来自某个字段，则不需要显示缩进
        buffer.write("${getDeepSpace(deep)}");
      }
      buffer.write("{");
      if (list.isEmpty) {
        //当map为空，直接返回‘}’
        buffer.write("}");
      } else {
        buffer.write("\n");
        for (int i = 0; i < list.length; i++) {
          buffer.write("${getDeepSpace(nextDeep)}\"${list[i]}\":");
          buffer.write(convert(object[list[i]], nextDeep, isObject: true));
          if (i < list.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}}");
      }
    } else if (object is List) {
      if (!isObject) {
        //如果list来自某个字段，则不需要显示缩进
        buffer.write("${getDeepSpace(deep)}");
      }
      buffer.write("[");
      if (object.isEmpty) {
        //当list为空，直接返回‘]’
        buffer.write("]");
      } else {
        buffer.write("\n");
        for (int i = 0; i < object.length; i++) {
          buffer.write(convert(object[i], nextDeep));
          if (i < object.length - 1) {
            buffer.write(",");
            buffer.write("\n");
          }
        }
        buffer.write("\n");
        buffer.write("${getDeepSpace(deep)}]");
      }
    } else if (object is String) {
      //为字符串时，需要添加双引号并返回当前内容
      buffer.write("\"$object\"");
    } else if (object is num || object is bool) {
      //为数字或者布尔值时，返回当前内容
      buffer.write(object);
    } else {
      //如果对象为空，则返回null字符串
      buffer.write("null");
    }
    return buffer.toString();
  }

  ///获取缩进空白符
  static String getDeepSpace(int deep) {
    var tab = StringBuffer();
    for (int i = 0; i < deep; i++) {
      tab.write("\t");
    }
    return tab.toString();
  }
}

extension ListAdd on List {
  /// 新增元素到 List 中，最大 20个。并进行特殊格式化。
  List addObject(var obj) {
    if (!AppDebug.isOpenDebug) return [];
    List end = this;
    var jsonMap;
    if (obj.toString().startsWith("{\"")) {
      jsonMap = jsonDecode(obj.toString()); //先把字符串json 转 map
    } else {
      jsonMap = obj;
    }
    String str = AppDebug.convert(jsonMap, 4); // map to json
    end.insert(0, str);
    if (end.length > 20) {
      end = end.sublist(0, 20);
    }
    return end;
  }
}

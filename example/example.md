
# How to use

## 0x01 Use this package as a library
1. **Depend on it**
Add this to your package's pubspec.yaml file:

        dependencies:
          app_debug: ^1.0.0
2. **Install it**
You can install packages from the command line:
with Flutter:

        $ flutter pub get
    Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

1. **Import it**

    Now in your Dart code, you can use:
    import 'package:app_debug/app_debug.dart';

-----------------------

## 0x02 Init GestureDetector actions

**In about_us_page, at version show.**
Add a GestureDetector, and isManuel set true.
```
GestureDetector(
  onTap: (){
    AppDebug.showDebugTool(context,isManuel: true);
  },
  child: _getCellWithItem(_Type.CellVersion),
),
```

--------------------

## 0x03 Show it wherever you want.
**In splash_page or home_page, init AppDebug.**
The first page of finish launching.

```
 @override
  void initState() {
    super.initState();
    // 初始化调试工具
    _initAppDebug ();
  }

  void _initAppDebug (){
    AppDebug.showDebugTool(context); // 初始化 AppDebug。 在 关于界面 配置 AppDebug.showDebugTool(context,isManuel: true); 后生效
    AppDebug.instance.apiSelected = Global.getApiUrl(); // 设置当前环境
    AppDebug.instance.apiList.add(ApiUrlConfig.API_DEV_URL); //添加 dev 环境 host
    AppDebug.instance.apiList.add(ApiUrlConfig.API_TEST_URL);  //添加 test 环境 host
    AppDebug.instance.apiList.add(ApiUrlConfig.API_BETA_URL); //添加 beta 环境 host
    AppDebug.instance.apiList.add(ApiUrlConfig.API_PRODUCT_URL); //添加 product 环境 host
    AppDebug.instance.apiSelectedCallback = (String api){ // api host 变更后回调
      Global.env = ENV.values[AppDebug.instance.apiList.indexOf(api)];
    };
  }
```
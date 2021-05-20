
# How to use

## 0x01 Use this package as a library
1. **Depend on it**
Add this to your package's pubspec.yaml file:

        dependencies:
          app_debug: ^1.1.0
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
  child: [YOU_WIDGET],
),
```

--------------------

## 0x03 Add api request log.

At base request file. Add response, queryParameters, data, headers and url.

```
   AppDebug.instance.data.addObject({
      "url":"${response.request.baseUrl+response.request.path}",
      "queryParameters":json.encode(response.request.queryParameters),
      "headers":json.encode(response.request.headers),
      "response":jsonDecode(response.toString()),
      '---':'------------------------------'
    });
```

------------------

## 0x04 init it  after App launch.
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
    AppDebug.instance.apiSelectedCallback = (String api){ // api host 变更后回调

    };
  }
```
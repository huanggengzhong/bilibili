import 'dart:convert';

import 'package:bilibili_app/db/hi_cache.dart';
import 'package:bilibili_app/http/core/hi_error.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:flutter/material.dart';

import 'model/test_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "fluttertterfluttertter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "fluttertter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page2222'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  //初始化生命周期
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiCache.preInit(); //初始化缓存
  }

  void _incrementCounter() async {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });
    //下面依次是学习增加的方法:
    //测试自己封装的hinet方法

    // TestRequest request = TestRequest();
    // // request.add("aa", "ddd").add("bb", "333");
    // request
    //     .add("aa", "ddd")
    //     .add("bb", "333")
    //     .add("requestPrams", "kkk"); //接口需要的参数
    //
    // //使用异常捕获
    // try {
    //   var result = await HiNet.getInstance().fire(request);
    //   print("main中的result:$result");
    // } on NeedAuth catch (e) {
    //   print("main中的NeedAuth:$e");
    // } on NeedLogin catch (e) {
    //   print("main中的NeedLogin:$e");
    // } on HiNetError catch (e) {
    //   print("main中的HiNetError:$e");
    // } catch (e) {
    //   print("main中的其它e:$e");
    // }

    //测试本地数据转换
    // test();

    //  测试手写model数据转换
    // test1();

    //  测试网页版的转换方法
    // test2();

    //  测试封装的缓存方法
    // test3();

    //测试登录接口
    testLogin();
  }

  //本地json和map数据转换:
  void test() {
    //json转map
    const jsonString =
        "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    print("jsonMap:$jsonMap");
    print("map取值1:${jsonMap['name']}");
    print("map取值2:${jsonMap['url']}");
    //  map转json
    String json = jsonEncode(jsonMap);
    print("重新得到json:$json");
  }

  void test1() {
    // var ownerMap = {
    //   "name": "伊零Onezero",
    //   "face":
    //       "http://i2.hdslb.com/bfs/face/1c57a17a7b077ccd19dba58a981a673799b85aef.jpg",
    //   "fans": 0
    // };
    // Owner owner = Owner.fromJson(ownerMap);
    // print("name:${owner.name}");
    // print("face:${owner.face}");
    // print("fans:${owner.fans}");
  }

  void test2() {
    dynamic jsonStr = {
      "id": "5633",
      "vid": "BV1q4411Y7zY",
      "title": "精神病人采访实录.突然觉得他们是那么的正常…",
      "tname": "影视剪辑",
      "url": "https://o.devio.org/files/video/BV1yt4y1Q7SS.mp4",
      "cover":
          "http://i1.hdslb.com/bfs/archive/4d628fdc730243c78ad393fe1ab7d6a43ab7d0c7.jpg",
      "pubdate": 1557474141,
      "desc": "剪自《人间世》很棒的纪录片，没做好准备千万别去看。",
      "view": 1333965,
      "duration": 145,
      "owner": {
        "name": "锦书致南辞",
        "face":
            "http://i0.hdslb.com/bfs/face/3f79d1df624218ab9a7774682fdb1d50a407ff88.jpg",
        "fans": 0
      },
      "reply": 2202,
      "favorite": 15392,
      "like": 36864,
      "coin": 3344,
      "share": 1841,
      "createTime": "2022-11-15 12:53:27",
      "size": 8161
    };

    dynamic mo = Autogenerated.fromJson(jsonStr);
    print("mo取值:${mo.vid}");
  }

  void test3() {
    HiCache.getInstance().setString("aa", "123456");
    var value = HiCache.getInstance().get("aa");
    print("缓存类的值:$value");
  }

  void testLogin() async {
    try {
      //登录
      var result2 = await LoginDao.login(
        "admin",
        "123",
      );
      //注册(这里请求会报500,接口要通过app来注册)
      // var result2 =
      //     await LoginDao.registration("admin", "123", "6597869", "7177");
      print("测试登录dao:$result2");
    } on NeedAuth catch (e) {
      print("测试登录NeedAuth:$e");
    } on HiNetError catch (e) {
      print("测试登录HiNetError:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

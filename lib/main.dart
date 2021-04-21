import 'package:bilibili_app/page/video_detail_page.dart';
import 'package:flutter/material.dart';

import 'model/video_model.dart';
import 'page/home_page.dart';

void main() {
  runApp(BiliApp());
  // runApp(MyApp());
}

class BiliApp extends StatefulWidget {
  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  //创建路由实例
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  //创建路由Parser实例
  BiliRouteInformationParser _routeInformationParser =
      BiliRouteInformationParser();
  @override
  Widget build(BuildContext context) {
    //定义route
    var widget = Router(
      routeInformationParser: _routeInformationParser,
      routerDelegate: _routeDelegate,
      routeInformationProvider: PlatformRouteInformationProvider(
          //当routeInformationParser不为空的时候要设置这个
          initialRouteInformation: RouteInformation(location: "/") //初始化打开首页
          ),
    );
    return MaterialApp(home: widget);
  }
}

//2.0路由学习

//2.创建路由代理

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  //依次实现下面三个方法

//  为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  final GlobalKey<NavigatorState>
      navigatorKey; //PopNavigatorRouterDelegateMixin源码要求要有navigatorKey
//构造方法初始化
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  //创建pages集合
  List<MaterialPage> pages = [];

  //创建VideoModel变量
  VideoModel videoModel;
//创建path变量
  BiliRoutePath path;

  @override
  Widget build(BuildContext context) {
    //构建路由堆栈
    pages = [
      //把首页放在栈顶
      pageWrap(HomePage(
        onJumpToDetail: (videoModel) {
          this.videoModel = videoModel;
          notifyListeners(); //通知数据变化
        },
      )), //首页
      if (videoModel != null)
        pageWrap(VideoDetailPage(videoModel)) //这里加了判断,如果videoModel不为空则显示详情页
    ];

    //build方法返回堆栈信息
    // TODO: implement build
    // navigationKey.currentState.比如这里可以获取它的很多方法
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        //查源码看到bool Function(Route<dynamic> route, dynamic result);作用:控制是否可以返回上一页
        if (!route.didPop(result)) {
          //在弹出路由前，会调用Route.didPop方法，也可以看到就算之前Route.willPop返回值为pop，仍然可以在Route.didPop返回false改变这个行为，从而不弹出路由。
          // 但是如果Route.didPop方法返回的是true，就会把当前路由弹出.
          return false;
        }
        return true;
      },
    );
  }

  // @override
  // // TODO: implement navigatorKey
  // GlobalKey<NavigatorState> get navigatorKey => throw UnimplementedError();

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    // TODO: implement setNewRoutePath
    // throw UnimplementedError();
    this.path = path;
  }
}

//1.创建路由Parser
class BiliRouteInformationParser extends RouteInformationParser {
  //必须要实现的抽象方法
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("BiliRouteInformationParser中的参数:$routeInformation");
    final uri = Uri.parse(routeInformation.location);
    print(uri);
    /*uri.Segments是返回以/分割的数组,下面是案例
    *  Uri uriAddress1 = new Uri(http://www.contoso.com/title/index.htm);
       uriAddress1.Segments[0] /
       uriAddress1.Segments[1] title/
    * */
    if (uri.pathSegments.length == 0) {
      return BiliRoutePath.home();
    }
    return BiliRoutePath.detail();
  }
}

//定义泛型
class BiliRoutePath {
  //定义path
  final String location;
//  下面是命名构造函数,并初始化
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "/detail";
}

//创建页面
pageWrap(Widget child) {
  return MaterialPage(
      key: ValueKey(child.hashCode), //hashCode获取哈希码
      child: child);
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     //初始化缓存放到最顶级,防止The method 'setString' was called on null.报错
//     HiCache.preInit();
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "fluttertterfluttertter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "fluttertter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(), //使用写好的登录页面
//       // home: RegistrationPage(), //使用写好的注册页面
//       // home: MyHomePage(title: 'Flutter Demo Home Page2222'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   //初始化生命周期
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // HiCache.preInit(); //初始化缓存
//   }
//
//   void _incrementCounter() async {
//     // setState(() {
//     //   // This call to setState tells the Flutter framework that something has
//     //   // changed in this State, which causes it to rerun the build method below
//     //   // so that the display can reflect the updated values. If we changed
//     //   // _counter without calling setState(), then the build method would not be
//     //   // called again, and so nothing would appear to happen.
//     //   _counter++;
//     // });
//     //下面依次是学习增加的方法:
//     //测试自己封装的hinet方法
//
//     // TestRequest request = TestRequest();
//     // // request.add("aa", "ddd").add("bb", "333");
//     // request
//     //     .add("aa", "ddd")
//     //     .add("bb", "333")
//     //     .add("requestPrams", "kkk"); //接口需要的参数
//     //
//     // //使用异常捕获
//     // try {
//     //   var result = await HiNet.getInstance().fire(request);
//     //   print("main中的result:$result");
//     // } on NeedAuth catch (e) {
//     //   print("main中的NeedAuth:$e");
//     // } on NeedLogin catch (e) {
//     //   print("main中的NeedLogin:$e");
//     // } on HiNetError catch (e) {
//     //   print("main中的HiNetError:$e");
//     // } catch (e) {
//     //   print("main中的其它e:$e");
//     // }
//
//     //测试本地数据转换
//     // test();
//
//     //  测试手写model数据转换
//     // test1();
//
//     //  测试网页版的转换方法
//     // test2();
//
//     //  测试封装的缓存方法
//     // test3();
//
//     //测试登录接口
//     // testLogin();
//
//     //  测试要登录接口
//     testNotice();
//   }
//
//   //本地json和map数据转换:
//   void test() {
//     //json转map
//     const jsonString =
//         "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
//     Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//     print("jsonMap:$jsonMap");
//     print("map取值1:${jsonMap['name']}");
//     print("map取值2:${jsonMap['url']}");
//     //  map转json
//     String json = jsonEncode(jsonMap);
//     print("重新得到json:$json");
//   }
//
//   void test1() {
//     // var ownerMap = {
//     //   "name": "伊零Onezero",
//     //   "face":
//     //       "http://i2.hdslb.com/bfs/face/1c57a17a7b077ccd19dba58a981a673799b85aef.jpg",
//     //   "fans": 0
//     // };
//     // Owner owner = Owner.fromJson(ownerMap);
//     // print("name:${owner.name}");
//     // print("face:${owner.face}");
//     // print("fans:${owner.fans}");
//   }
//
//   void test2() {
//     dynamic jsonStr = {
//       "id": "5633",
//       "vid": "BV1q4411Y7zY",
//       "title": "精神病人采访实录.突然觉得他们是那么的正常…",
//       "tname": "影视剪辑",
//       "url": "https://o.devio.org/files/video/BV1yt4y1Q7SS.mp4",
//       "cover":
//           "http://i1.hdslb.com/bfs/archive/4d628fdc730243c78ad393fe1ab7d6a43ab7d0c7.jpg",
//       "pubdate": 1557474141,
//       "desc": "剪自《人间世》很棒的纪录片，没做好准备千万别去看。",
//       "view": 1333965,
//       "duration": 145,
//       "owner": {
//         "name": "锦书致南辞",
//         "face":
//             "http://i0.hdslb.com/bfs/face/3f79d1df624218ab9a7774682fdb1d50a407ff88.jpg",
//         "fans": 0
//       },
//       "reply": 2202,
//       "favorite": 15392,
//       "like": 36864,
//       "coin": 3344,
//       "share": 1841,
//       "createTime": "2022-11-15 12:53:27",
//       "size": 8161
//     };
//
//     dynamic mo = Autogenerated.fromJson(jsonStr);
//     print("mo取值:${mo.vid}");
//   }
//
//   void test3() {
//     HiCache.getInstance().setString("aa", "123456");
//     var value = HiCache.getInstance().get("aa");
//     print("缓存类的值:$value");
//   }
//
//   void testLogin() async {
//     try {
//       //登录
//       var result2 = await LoginDao.login(
//         "admin",
//         "123",
//       );
//       //注册(这里请求会报500,接口要通过app来注册)
//       // var result2 =
//       //     await LoginDao.registration("admin", "123", "6597869", "7177");
//       print("测试登录dao:$result2");
//     } on NeedAuth catch (e) {
//       print("测试登录NeedAuth:$e");
//     } on HiNetError catch (e) {
//       print("测试登录HiNetError:$e");
//     }
//   }
//
//   void testNotice() async {
//     print("testNotice测试");
//     try {
//       var notice = await HiNet.getInstance().fire(NoticeRequest());
//     } on NeedLogin catch (e) {
//       print("testNotice_needlogin:$e");
//     } on NeedAuth catch (e) {
//       print("testNotice_NeedAuth:$e");
//     } on HiNetError catch (e) {
//       print("testNotice_HiNetError:${e.message}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

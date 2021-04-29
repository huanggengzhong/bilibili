import 'package:bilibili_app/db/hi_cache.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/page/login_page.dart';
import 'package:bilibili_app/page/registration_page.dart';
import 'package:bilibili_app/page/video_detail_page.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:flutter/material.dart';

import 'navigator/bottom_navigator.dart';
import 'navigator/hi_navigator.dart';
import 'util/color.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  //创建路由实例
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    //定义route
    // MaterialApp(home: widget);改造成FutureBuilder
    return FutureBuilder<HiCache>(
        //进行初始化
        future: HiCache.preInit(), //先初始化缓存
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //增加判断是否加载完成来显示loading
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            home: widget,
            theme: ThemeData(
              primarySwatch: white,
            ),
          );
        });
  }
}

//2.0路由学习

//2.创建路由代理

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  //依次实现下面方法

//  为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  final GlobalKey<NavigatorState>
      navigatorKey; //PopNavigatorRouterDelegateMixin源码要求要有navigatorKey
//构造方法初始化
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args['videoMo'];
      }
      notifyListeners();
    }));
  }
  //定义路由状态,默认主页
  RouteStatus _routeStatus = RouteStatus.home;

  //创建pages集合
  List<MaterialPage> pages = [];

  //创建VideoModel变量
  VideoMo videoModel;

//创建path变量
//   BiliRoutePath path;

  @override
  Widget build(BuildContext context) {
    //新的管理路由堆栈
    var index = getPageIndex(pages, routeStatus); //通过get方法来获取
    //定义临时变量,如果路由在堆栈里,则将该页面和它上面的所有页面进行出栈
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
      /* List<int> list = [1, 2, 3, 4, 9, 8, 7, 6];
  print(list.sublist(2, 5));//[3, 4, 9]*/
    }
    //创建我们要的页面
    var page;
    if (routeStatus == RouteStatus.home) {
      //首页不可回退,清空即可
      pages.clear();
      //重新创建首页
      page = pageWrap(BottomNavigator()); //首页
      // page = pageWrap(HomePage()); //首页
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      //注册页
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      //登录页
      page = pageWrap(LoginPage());
    }

    //重新创建一个数组,否则pages因引用没有改变不会生效
    tempPages = [...tempPages, page];

    //通知所有路由变化
    HiNavigator.getInstance().notify(tempPages, pages); //新前,旧后

    pages = tempPages;

    //build方法返回堆栈信息
    // TODO: implement build
    // navigationKey.currentState.比如这里可以获取它的很多方法

    return WillPopScope(
        child: Navigator(
          //WillPopScope可以监听物理返回键
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            //增加登陆页未登陆进行提示拦截
            // print("aaaaa:${(route.settings as MaterialPage).child}");
            // if ((route.settings as MaterialPage).child is RegistrationPage) {//测试
            if ((route.settings as MaterialPage).child is LoginPage) {
              //as 是强类型转换
              if (!hasLogin) {
                showWarnToast("请先登录");
                return false;
              }
            }

            //查源码看到bool Function(Route<dynamic> route, dynamic result);作用:控制是否可以返回上一页
            if (!route.didPop(result)) {
              //在弹出路由前，会调用Route.didPop方法，也可以看到就算之前Route.willPop返回值为pop，仍然可以在Route.didPop返回false改变这个行为，从而不弹出路由。
              // 但是如果Route.didPop方法返回的是true，就会把当前路由弹出.
              return false;
            }
            var tempPages = [...pages];
            pages.removeLast();
            //通知路由变化
            HiNavigator.getInstance().notify(pages, tempPages); //新前,旧后
            return true;
          },
        ),
        //修复安卓物理返回键无法返回上一页问题(不加的话从登陆-注册再按物理返回无法回到登陆)
        onWillPop: () async => !await navigatorKey.currentState.maybePop());
  }

  RouteStatus get routeStatus {
    //这里拦截路由
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      //不是注册页面并且没有登录,返回登录页去
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      //返回当前路由状态
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  // @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    // TODO: implement setNewRoutePath
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

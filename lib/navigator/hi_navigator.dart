import 'package:bilibili_app/navigator/bottom_navigator.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/login_page.dart';
import 'package:bilibili_app/page/registration_page.dart';
import 'package:bilibili_app/page/video_detail_page.dart';
import 'package:flutter/material.dart';

//定义路由监听fn
typedef RouteChangeListenr(RouteStatusInfo current, RouteStatusInfo pre);

//创建页面
pageWrap(Widget child) {
  return MaterialPage(
      key: ValueKey(child.hashCode), //hashCode获取哈希码
      child: child);
}

//路由封装

//获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i]; //下标
    if (getStatus(page) == routeStatus) {
      return i;
    }
    return -1;
  }
}

// 定义路由状态

enum RouteStatus { login, registration, home, detail, unknown }

//获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

//路由信息(根据路由枚举状态返回页面)
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

//监听当前页面上方压后台
class HiNavigator extends _RouteJumpListener {
  //创建单例
  static HiNavigator _instance;

  RouteJumpListener _routeJump;

  //创建路由监听集合
  List<RouteChangeListenr> _listeners = [];

  //定义一个打开过的页面变量
  RouteStatusInfo _current;

  //定义一个底部tab变量
  RouteStatusInfo _bottomTab;

  //单例构造方法
  HiNavigator._();
  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance;
  }
  //获取当前页
  RouteStatusInfo getCurrent(){
    return _current;
  }

  //底部tab监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab);
  }

  //注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  //监听路由页面跳转(添加方法)
  void addListener(RouteChangeListenr listenr) {
    if (!_listeners.contains(listenr)) {
      //如果不在数组里
      _listeners.add(listenr);
    }
  }

  //监听路由页面跳转(移除方法)
  void removeListener(RouteChangeListenr listenr) {
    _listeners.remove(listenr);
  }

  //跳转方法
  @override
  void onJumpTo(RouteStatus routeStatus, {Map args}) {
    // TODO: implement onJumpTo
    _routeJump.onJumpTo(routeStatus, args: args);
  }

  //通知路由页面变化方法
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    //获取当前路由信息
    var current = RouteStatusInfo(
        getStatus(currentPages.last), currentPages.last.child); //栈中最顶部的就是当前页面
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    //添加首页tab切换监听
    if (current.page is BottomNavigator && _bottomTab != null) {
      //明确到具体的tab
      current = _bottomTab;
    }

    //通知页面变化
    print("_notify,current当前页面:${current.page}");
    print("_notify,_current打开后的页面:${_current?.page}");
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current; //本地永远是上一次打开的页面
  }
}

//声明抽象类来监听跳转
abstract class _RouteJumpListener {
  //定义子类必须实现的跳转方法,参数1是跳转路由,参数2是map参数
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

//用typeof定义某个类型
typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map args});

//定义路由跳转逻辑要实现的跳转功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
//里面有一个非必填的onJumpTo方法
  RouteJumpListener({this.onJumpTo});
}

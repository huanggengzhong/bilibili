//状态栏方法
import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:bilibili_app/page/profile_page.dart';
import 'package:bilibili_app/page/video_detail_page.dart';
import 'package:bilibili_app/widget/navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

//带缓存的图片组件
Widget cachedImage(String url, {double width, double height}) {
  return CachedNetworkImage(
    width: width,
    height: height,
    imageUrl: url,
    placeholder: (context, url) => Container(
      color: Colors.grey[200],
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

void changeStatusBar(
    {color: Colors.white,
    StatusStyle statusStyle: StatusStyle.DARK_CONTENT,
    BuildContext context}) {
  // flutter_statusbar_manager插件:Flutter Statusbar Manager，可让您控制iOS和Android上的状态栏颜色，样式（主题），可见性和半透明属性。并为Android提供了一些额外的奖励来控制导航栏。

  //fix 安卓切换页面变白问题
  var page = HiNavigator.getInstance().getCurrent()?.page;
  //fix Android切换 profile页面状态栏变白问题
  if (page is ProfilePage) {
    color = Colors.transparent;
  } else if (page is VideoDetailPage) {
    color = Colors.black;
    statusStyle = StatusStyle.LIGHT_CONTENT;
  }
  //沉浸式状态栏样式
  FlutterStatusbarManager.setColor(color, animated: false);
  FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
      ? StatusBarStyle.DARK_CONTENT
      : StatusBarStyle.LIGHT_CONTENT);
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ],
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter);
}

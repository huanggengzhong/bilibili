//状态栏方法
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
    {color: Colors.white, StatusStyle statusStyle: StatusStyle.DARK_CONTENT}) {
  // flutter_statusbar_manager插件:Flutter Statusbar Manager，可让您控制iOS和Android上的状态栏颜色，样式（主题），可见性和半透明属性。并为Android提供了一些额外的奖励来控制导航栏。
  FlutterStatusbarManager.setColor(color, animated: false);
  FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
      ? StatusBarStyle.DARK_CONTENT
      : StatusBarStyle.LIGHT_CONTENT);
}

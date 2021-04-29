//顶部导航栏
import 'package:bilibili_app/util/view_util.dart';
import 'package:flutter/material.dart';
//定义枚举状态
enum StatusStyle {LIGHT_CONTENT,DARK_CONTENT};

class NavigationBar extends StatefulWidget {
  //传递的变量
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget child;

  const NavigationBar({Key key, this.statusStyle=StatusStyle.DARK_CONTENT, this.color=Colors.white, this.height=46, this.child}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化状态
    _statusBarInit();
  }
  @override
  Widget build(BuildContext context) {
    //状态栏高度
    var top=MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top +widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top:top),
      decoration: BoxDecoration(color: widget.color),
    );
  }

  void _statusBarInit() {
    changeStatusBar(color:widget.color,statusStyle:widget.statusStyle);
  }
}


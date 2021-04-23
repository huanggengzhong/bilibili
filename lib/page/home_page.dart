import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //定义变量fn
  var listener;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //注册路由监听
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print("homepage监听current:${current.page}");
      print("homepage监听pre:${pre.page}");
      if (widget == current.page || current.page is HomePage) {
        print("路由监听方法:打开了首页,相当于onResume钩子");
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print("路由监听方法:离开了首页,被隐藏后台了,相当于onPause钩子");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //移除监听
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("首页"),
          MaterialButton(
            onPressed: () {
              HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
                  args: {"videoMo": VideoModel(1001)});
            },
            child: Text("详情"),
          )
        ],
      ),
    );
  }
}

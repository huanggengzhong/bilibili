import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:bilibili_app/page/home_tab_page.dart';
import 'package:bilibili_app/util/color.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //解决切换回来没有监听的问题AutomaticKeepAliveClientMixin
  //定义变量fn
  var listener;
  //定义首页tab
  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];
  //tab控制器
  TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //控制器初始化
    _controller = TabController(
        length: tabs.length,
        vsync:
            this); //vsync要传递一个TickerProvider,上面进行混入TickerProviderStateMixin即可

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
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          //Flexible使用充满组件
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: tabs.map((tab) {
              return HomeTabPage(name: tab);
            }).toList(),
          )),
          // Text("首页"),
          // MaterialButton(
          //   onPressed: () {
          //     HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
          //         args: {"videoMo": VideoModel(1001)});
          //   },
          //   child: Text("详情"),
          // )
        ],
      ),
    );
  }

  _tabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      labelColor: Colors.black,
      //下划线组件
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.round, // Set your line endings.
          borderSide: BorderSide(
            color: primary,
            width: 3,
          ),
          insets: EdgeInsets.only(left: 15, right: 15)),
      tabs: tabs.map((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}

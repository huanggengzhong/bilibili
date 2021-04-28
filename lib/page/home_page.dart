import 'package:bilibili_app/core/hi_state.dart';
import 'package:bilibili_app/http/core/hi_error.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:bilibili_app/page/home_tab_page.dart';
import 'package:bilibili_app/util/color.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
// class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //解决切换回来没有监听的问题AutomaticKeepAliveClientMixin
  //定义变量fn
  var listener;

  //tab控制器
  TabController _controller;
  //定义首页tab
  // var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];
  //tabs 换成接口分类数据
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //控制器初始化
    _controller = TabController(
        length: categoryList.length,
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
    loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //移除监听
    HiNavigator.getInstance().removeListener(this.listener);
    _controller.dispose();
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
            children: categoryList.map((tab) {
              return HomeTabPage(
                name: tab.name,
                bannerList: tab.name == '推荐' ? bannerList : null,
              );
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
      tabs: categoryList.map((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }

//调用接口方法
  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("推荐");
      print('loadData():$result');
      if (result.categoryList != null) {
        //tab长度变化后需要重新创建TabController,避免报错
        _controller =
            TabController(length: result.categoryList.length, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList;
        bannerList = result.bannerList;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}

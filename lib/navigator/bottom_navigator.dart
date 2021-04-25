import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:bilibili_app/page/favorite_page.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/profile_page.dart';
import 'package:bilibili_app/page/ranking_page.dart';
import 'package:bilibili_app/util/color.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0; //pageview导航页面索引
  final PageController _controller =
      PageController(initialPage: initialPage); //pageview导航控制器
  List<Widget> _pages;
  bool _hasBuild = false;
  @override
  Widget build(BuildContext context) {
    _pages=[HomePage(),RankingPage(),FavoritePage(),ProfilePage()];
    //页面第一次打开是通知打开的是哪个tab
    if(!_hasBuild){
      HiNavigator.getInstance().onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild=true;
    }

    return Scaffold(
      body: PageView(
        //PageView是页面切换组件
        controller: _controller,
        onPageChanged: (index) => _onJumpto(index, pageChange: true),
        children: [HomePage(), RankingPage(), FavoritePage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _activeColor,
        onTap: (index) => _onJumpto(index, pageChange: false),
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem("首页", Icons.home, 0),
          _bottomItem("排行", Icons.local_fire_department, 1),
          _bottomItem("收藏", Icons.favorite, 2),
          _bottomItem("我的", Icons.live_tv, 3),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int i) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        label: title,
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ));
  }

  _onJumpto(int index, {pageChange = false}) {
    if (!pageChange) {
      //让PageView展示对应tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }

    setState(() {
      _currentIndex = index;
    });
  }
}

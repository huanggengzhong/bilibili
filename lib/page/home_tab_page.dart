import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/widget/hi_banner.dart';
import 'package:flutter/material.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo> bannerList;
  const HomeTabPage({Key key, this.categoryName, this.bannerList})
      : super(key: key);
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [if (widget.bannerList != null) _banner()], //语法存在即调用
      ),
    );
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Hibanner(widget.bannerList),
    );
  }
}

import 'package:bilibili_app/http/core/hi_error.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:bilibili_app/widget/hi_banner.dart';
import 'package:bilibili_app/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo> bannerList;
  const HomeTabPage({Key key, this.categoryName, this.bannerList})
      : super(key: key);
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoMo> videoList = [];
  int pageIndex = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  加载数据
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    //xia消除间距组件
    return MediaQuery.removePadding(
        //MediaQuery.removePadding是移除padd ing组件
        removeTop: true,
        context: context,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: videoList.length,
          itemBuilder: (BuildContext context, int index) {
            if (widget.bannerList != null && index == 0) {
              //有banner时第一个位置显示banner
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _banner(),
              );
            } else {
              return VideoCard(videoMo: videoList[index]);
            }
          },
          staggeredTileBuilder: (int index) {
            //显示几行
            if (widget.bannerList != null && index == 0) {
              return StaggeredTile.fit(2);
            } else {
              return StaggeredTile.fit(1);
            }
          },
        ));
    // child: Container(
    //   child: ListView(
    //     children: [if (widget.bannerList != null) _banner()], //语法存在即调用
    //   ),
    // ));
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Hibanner(widget.bannerList),
    );
  }

//调用接口方法
  void _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 50);
      print('loadData():$result');
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}

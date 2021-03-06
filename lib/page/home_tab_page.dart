import 'package:bilibili_app/http/core/hi_error.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/util/color.dart';
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
  bool _loading = false;
  //创建上拉加载更多控制器
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //监听滚动
    _scrollController.addListener(() {
      //获取滚动距离(最大-当前的距离)
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print("dis:$dis");
      if (dis < 300 && !_loading) {
        _loadData(loadMore: true);
      }
    });
    //  加载数据
    _loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //xia消除间距组件
    return RefreshIndicator(
      color: primary,
      onRefresh: _loadData,
      child: MediaQuery.removePadding(
          //MediaQuery.removePadding是移除padd ing组件
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(), //当不足一屏也可以滚动
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
          )),
    );
    ;
    // child: Container(
    //   child: ListView(
    //     children: [if (widget.bannerList != null) _banner()], //语法存在即调用
    //   ),
    // ));
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Hibanner(widget.bannerList),
    );
  }

//调用接口方法
  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('currentIndex444444:$currentIndex');
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
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
      //延迟开关
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      showWarnToast(e.message);
    }
  }
}

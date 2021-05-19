import 'dart:io';

import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/util/view_util.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/navigation_bar.dart';
import 'package:bilibili_app/widget/video_view.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo videoModel; //传递VideoMo对象

  const VideoDetailPage(this.videoModel);
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //给安卓设置状态栏
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          context: context,
          removeTop: Platform.isIOS,
          child: Column(
            children: [
              NavigationBar(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
              ),
              _videoView(),
              // Text("视频详情页,得到的id:${widget.videoModel.vid}"),
              // Text("视频详情页,得到的title:${widget.videoModel.title}"),
              _buildTabNavigation(),
            ],
          )),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(model.url,
        cover: model.cover, autoPlay: true, overlayUI: videoAppBar());
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tabBar()],
        ),
      ),
    );
  }

  _tabBar() {}
}

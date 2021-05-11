import 'package:bilibili_app/model/home_mo.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("视频详情页,得到的id:${widget.videoModel.vid}"),
          Text("视频详情页,得到的title:${widget.videoModel.title}"),
          _videoView()
        ],
      ),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      model.url,
      cover: model.cover,
    );
  }
}

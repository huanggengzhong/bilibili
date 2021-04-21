import 'package:bilibili_app/model/video_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel> onJumpToDetail;

  const HomePage({Key key, this.onJumpToDetail}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("首页"),
          MaterialButton(
            onPressed: () => widget.onJumpToDetail(VideoModel(1111)),
            child: Text("详情"),
          )
        ],
      ),
    );
  }
}

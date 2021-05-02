import 'package:bilibili_app/model/home_mo.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final VideoMo videoMo;

  const VideoCard({Key key, this.videoMo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(videoMo.url);
      },
      child: Image.network(videoMo.cover),
    );
  }
}

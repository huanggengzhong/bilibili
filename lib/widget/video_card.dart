import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/util/format_util.dart';
import 'package:bilibili_app/util/view_util.dart';
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
      child: SizedBox(
        height: 200,
        child: Card(
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_itemImage(context), _infoText()],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(videoMo.cover, width: size.width / 2 - 10, height: 120),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
            decoration: BoxDecoration(
                //渐变
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_iconText(Icons.ondemand_video, videoMo.view)],
            ),
          ),
        )
      ],
    );
  }

  _iconText(IconData iconData, int count) {
    String views = '';
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoMo.duration);
    }
    return Row(
      children: [
        if (iconData != null)
          Icon(
            iconData,
            color: Colors.white,
            size: 12,
          ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child:
              Text(views, style: TextStyle(color: Colors.white, fontSize: 10)),
        )
      ],
    );
  }

  _infoText() {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text(videoMo.title),
            //作者
          ],
        ),
      ),
    );
  }
}

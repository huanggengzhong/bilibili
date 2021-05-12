import 'package:bilibili_app/util/color.dart';
import 'package:bilibili_app/util/view_util.dart';
import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

import 'hi_video_controls.dart';

class VideoView extends StatefulWidget {
  final String url; //视频地址
  final String cover; //封面
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  const VideoView(this.url,
      {Key key,
      this.cover,
      this.autoPlay,
      this.looping,
      this.aspectRatio = 16 / 9})
      : super(key: key); //视频比例

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  //自带播放器和chewie播放器两个控制器
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
//get封面函数
  get _plaseholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover),
      );
  //进度条颜色
  get _progressColors => ChewieProgressColors(
      playedColor: primary, handleColor: primary, backgroundColor: Colors.grey);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化播放器
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.autoPlay,
        allowMuting: false, //是否允许禁音
        allowPlaybackSpeedChanging: false, //速度
        placeholder: _plaseholder,
        materialProgressColors: _progressColors, //进度条颜色
        customControls: MaterialControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,
          bottomGradient: blackLinearGradient(),
        ));

    //解决视频播放器退出全屏bug
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _chewieController.removeListener(_fullScreenListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //宽高
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: screenHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}

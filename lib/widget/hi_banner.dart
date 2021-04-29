import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
//这里单独对轮播组件进行插件封装,这样如果换的话也方便

class Hibanner extends StatelessWidget {
  final List<BannerMo> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry padding;

  const Hibanner(this.bannerList,
      {Key key, this.bannerHeight = 160, this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return _image(bannerList[index]);
      },
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: right, bottom: 10),
          builder: DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 6)),
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        _handleClick(bannerMo);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          //ClipRRect圆角裁剪组件
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: Image.network(
            bannerMo.cover,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _handleClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      print("VideoMo(vid: bannerMo.url):${VideoMo(vid: bannerMo.url)}");
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
          args: {'videoMo': VideoMo(vid: bannerMo.url)});
    } else {
      print("点击了banner:type是${bannerMo.type},url是:${bannerMo.url}");
    }
  }
}

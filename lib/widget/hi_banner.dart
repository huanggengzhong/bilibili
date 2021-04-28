import 'package:bilibili_app/model/home_mo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
      onTap: () {},
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
}

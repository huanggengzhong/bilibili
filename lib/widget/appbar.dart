import 'package:bilibili_app/util/view_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

appbar(String title, String rightTitle, VoidCallback rightButtonClick) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    centerTitle: false, //这样可以居左
    titleSpacing: 0,
    leading: BackButton(),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

//视频详情appbar
videoAppBar() {
  return Container(
    padding: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(
          color: Colors.white,
        ),
        Row(
          children: [
            Icon(
              Icons.live_tv_rounded,
              color: Colors.white,
              size: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

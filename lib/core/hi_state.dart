//解决setState called after dispose()异常问题
import 'package:flutter/material.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) {
      //mounted 是 bool 类型，表示当前 State 已加载到树⾥。
      super.setState(fn);
    } else {
      print('HiState:页面已销毁，本次setState不执行：${toString()}');
    }
  }
}

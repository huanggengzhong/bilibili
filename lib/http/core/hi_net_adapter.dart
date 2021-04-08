//统一返回格式适配器

import 'dart:convert';

import 'package:bilibili_app/http/request/base_request.dart';

//适配器抽象类
abstract class HiNetAdaper {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  T data;
  BaseRequest request;
  int statusCode;
  String statusMessage;
  dynamic extra;
  HiNetResponse(
      {this.data,
      this.request,
      this.statusCode,
      this.statusMessage,
      this.extra //额外参数
      });
  @override
  String toString() {
    if (data is Map) {
      //  将map转换成字符串
      return json.encode(data);
    }
    return data.toString();
  }
}

import 'package:bilibili_app/http/core/mock_adapter.dart';
import 'package:bilibili_app/http/request/base_request.dart';

import 'hi_error.dart';
import 'hi_net_adapter.dart';

class HiNet {
//  创建命名构造单例
  HiNet._();

  static HiNet _instance;

  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance;
  }

//fire请求
  Future fire(BaseRequest request) async {
    HiNetResponse response;
    var error;

    //捕获异常
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      //HiNetError类型的异常
      error = e;
      response = e.data;
      prinlog(e.message);
    } catch (e) {
      //  进入这里代码有其它异常
      error = e;
      prinlog(e);
    }
    //如果响应体为空,打印异常
    if (response == null) {
      prinlog(error);
    }

    var result = response.data;
    print("result:$result");
    //根据不同的错误状态码返回封装好的异常类
    var status = response.statusCode;
    switch (status) {
      case 200:
        return result;
        break;
      case 401:
        throw NeedLogin();
        break;
      case 403:
        throw NeedAuth(result.toString(), data: result);
        break;
      default:
        throw HiNetError(status, result.toString(), data: result);
        break;
    }
    return result;
  }

  //发送请求方法封装
  Future<dynamic> send<T>(BaseRequest request) async {
    prinlog("url:${request.url()}");
    prinlog("method:${request.httpMethod()}");
    request.addHeader("token", "123");
    prinlog("header:${request.header}");

    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 0, "message": "success"}
    // });
    //  使用HiNetAdapter模拟异常数据请求
    HiNetAdaper adaper = MockAdaptor();
    return adaper.send(request);
  }

//  统一打印方法
  void prinlog(log) {
    print("hi_net:${log.toString()}");
  }
}

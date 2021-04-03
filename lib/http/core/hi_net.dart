import 'package:bilibili_app/http/request/base_request.dart';

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
    var response = await send(request);
    var result = response['data'];
    print("result:$result");
    return result;
  }

  //发送请求方法封装
  Future<dynamic> send<T>(BaseRequest request) async {
    prinlog("url:${request.url()}");
    prinlog("method:${request.httpMethod()}");
    request.addHeader("token", "123");
    prinlog("header:${request.header}");
    return Future.value({
      "statusCode": 200,
      "data": {"code": 0, "message": "success"}
    });
  }

//  统一打印方法
  void prinlog(log) {
    print("hi_net:${log.toString()}");
  }
}

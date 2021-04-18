//登录数据访问对象

import 'package:bilibili_app/db/hi_cache.dart';
import 'package:bilibili_app/http/core/hi_net.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:bilibili_app/http/request/login_request.dart';
import 'package:bilibili_app/http/request/registration_request.dart';

class LoginDao {
  static const BOARING_PASS = 'boarding-pass'; //登录缓存数据
  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password, {imoocId, orderId}) async {
    //后两个是注册可选参数
    BaseRequest request;

    if (imoocId != null && orderId != null) {
      //  注册
      request = RegistrationRequest();
    } else {
      //登录
      request = LoginRequest();
    }
    request
        .add("userName", userName)
        .add("password", password)
        .add('imoocId', imoocId)
        .add('orderId', orderId);
    var result = await HiNet.getInstance().fire(request);
    print("login_dao的result:$result");
    if (result['code'] == 0 && result['data' != null]) {
      //  登录令牌缓存
      HiCache.getInstance().setString(BOARING_PASS, result['data']);
    }
    return result;
  }

  //获取缓存数据
  static getBoardingPass() {
    return HiCache.getInstance().get(BOARING_PASS);
  }
}

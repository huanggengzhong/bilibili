//登录异常
class NeedLogin extends HiNetError {
  NeedLogin({int code: 401, String message: '请先登录'}) : super(code, message);
}

//授权异常
class NeedAuth extends HiNetError {
  NeedAuth(String message, {int code: 403, dynamic data})
      : super(code, message, data: data);
}

//网络异常统一格式
class HiNetError implements Exception {
  //Exception是flutter异常的类,这里使用implements混入继承
  final int code;
  final String message;
  final dynamic data;
  HiNetError(this.code, this.message, {this.data}); //{this.data是可选参数}
}

//消息通知接口测试
import 'package:bilibili_app/http/request/base_request.dart';

class NoticeRequest extends BaseRequest{
  @override
  HttpMethod httpMethod() {
    // TODO: implement httpMethod
    return HttpMethod.GET;
  }
  @override
  bool needLogin() {
    // TODO: implement needLogin
    return true;
  }
  @override
  String path() {
    // TODO: implement path
    return "uapi/notice";
  }
}
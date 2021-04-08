import 'package:bilibili_app/http/core/hi_net_adapter.dart';
import 'package:bilibili_app/http/request/base_request.dart';

class MockAdaptor extends HiNetAdaper {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future<HiNetResponse>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          data: {"code": 0, "message": "success"}, statusCode: 403);
    });
  }
}

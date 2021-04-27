import 'package:bilibili_app/http/core/hi_net.dart';
import 'package:bilibili_app/http/request/home_request.dart';
import 'package:bilibili_app/model/home_mo.dart';

class HomeDao {
  static get(String categoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print("首页get分类请求结果:${result}");
    return HomeMo.fromJson(result['data']);
  }
}

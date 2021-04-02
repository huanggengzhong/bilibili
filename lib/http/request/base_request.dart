//枚举请求方法类型
enum HttpMethod { GET, POST, DELETE }

//封装基本的请求类
abstract class BaseRequest {
//  请求参数传递默认两种类型:
//  1.xxx/test?requestParams=11;2.xxx/11;

//变量

  var pathParams; //参数
  var useHttps = true; //是否https
  String authority() {
    //域名方法
    return 'api.devio.org';
  }

//  子类要实现的抽象方法(这三个是没方法体,子类必须要实现的)
  HttpMethod httpMethod(); //请求类型方法
  String path(); //域名和参数之间的地址方法
  bool needLogin(); //  生成是否要登录的方法

//生成url的方法
  String url() {
    Uri uri;
    var pathStr = path();
    // 根据两种不同的类型拼接path参数,endsWith()判断字符串是否以什么结尾
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    //  http和https的切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, pathParams); //Uri.https()是Uri类提供的方法
    } else {
      uri = Uri.http(authority(), pathStr, pathParams);
    }
    print("得到的url地址是:${uri.toString()}");
    return uri.toString();
  }

//  创建一个map,以便添加不同参数
  Map<String, String> params = Map();
//  添加不同参数的方法
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    print("打印add参数的this:${this}");
    return this;
  }

//  请求头参数
  Map<String, dynamic> header = Map();
//  添加请求头方法
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    print("打印addHeader的this:${this}");
    return this;
  }
}

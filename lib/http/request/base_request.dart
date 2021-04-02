//枚举请求方法类型
enum HttpMethod { GET, POST, DELETE }

//封装基本的请求类
abstract class BaseRequest {
//  请求参数传递默认两种类型:1.xxx/test?requestParams=11;2.xxx/11;

//变量

  var pathParams; //参数
  var useHttps = true; //是否https
  String authority() {
    //域名方法
    return 'api.devio.org';
  }
}

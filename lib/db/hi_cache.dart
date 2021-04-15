//缓存类封装
import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  //声明一个pref
  SharedPreferences prefs;

  HiCache._() {
    init();
  }

//  创建一个单例
  static HiCache _instance;
  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }
    return _instance;
  }

  //赋值方法
  HiCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

//  预初始化方法,防止在get时prefs还未初始化
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
  }

//  初始化方法
  void init() async {
    if (prefs == null) {
      //实例化
      prefs = await SharedPreferences.getInstance();
    }
  }
//  下面是各个缓存方法
setString(String key,String value){
    prefs.setString(key, value);
}
setDouble(String key,double value){
    prefs.setDouble(key, value);
}

setInt(String key,int value){
    prefs.setInt(key, value);
}
setBool(String key,bool value){
    prefs.setBool(key, value);
}
setStringList(String key,List<String> value){
    prefs.setStringList(key, value);
}
//取值泛型方法
T get<T>(String key){
    return prefs.get(key);
}
}

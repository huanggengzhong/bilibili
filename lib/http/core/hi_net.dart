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
}

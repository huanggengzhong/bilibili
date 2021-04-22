import 'package:bilibili_app/http/core/hi_error.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/navigator/hi_navigator.dart';
import 'package:bilibili_app/util/string_util.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_button.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool enable = false; //是否可以点击
  String userName;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar("登录", "注册", () {
        //HiNavigator跳转
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(
              protect: protect,
            ),
            LoginInput(
              "用户名",
              "请输入用户名",
              onChanged: (v) {
                setState(() {
                  userName = v;
                  checkInput();
                });
              },
            ),
            LoginInput(
              "密   码",
              "请输入登录密码",
              focusChanged: (v) {
                setState(() {
                  protect = v;
                });
              },
              onChanged: (v) {
                setState(() {
                  password = v;
                  checkInput();
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: LoginButton(
                '登录',
                enable: enable,
                onPressed: checkparams,
              ),
            )
          ],
        ),
      ),
    );
  }

//检验是否可以登录
  void checkInput() {
    if (isNotEmpty(userName) && isNotEmpty((password))) {
      setState(() {
        enable = true;
      });
    } else {
      setState(() {
        enable = false;
      });
    }
  }

//
  void checkparams() {
    String tips;
    if (userName == null) {
      tips = "请输入用户名";
    } else if (password == null) {
      tips = "请输入密码";
    }
    if (tips != null) {
      showWarnToast(tips);
    }
    //通过验证,发送请求
    _send();
  }

  void _send() async {
    try {
      var result = await LoginDao.login(userName, password);
      print("result22222:${result['code']}");
      if (result['code'] == 0) {
        showToast("登录成功");
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    } catch (e) {
      print("登录其它err:$e");
    }
  }
}

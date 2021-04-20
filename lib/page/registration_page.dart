import 'package:bilibili_app/http/core/hi_error.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/util/string_util.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_button.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;

  const RegistrationPage({Key key, this.onJumpToLogin}) : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false; //是否保护状态
  bool loginEnable = false; //是否可以点击
  String userName;
  String password;
  String rePassword;
  String imoocId;
  String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar("登录", "注册", widget.onJumpToLogin),
      body: Container(
        child: ListView(
          //ListView好处可以使键盘弹起
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              "用户名",
              "请输入用户名",
              lineStretch: true,
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              "密码",
              "请输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (val) {
                this.setState(() {
                  protect = val;
                });
              },
            ),
            LoginInput(
              "确认密码",
              "请再次输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (val) {
                this.setState(() {
                  protect = val;
                });
              },
            ),
            LoginInput(
              "慕课网ID",
              "请输入您的慕课网用户ID",
              lineStretch: true,
              obscureText: false,
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            LoginInput(
              "课程订单号",
              "请输入您的课程订单号",
              lineStretch: true,
              obscureText: false,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton('注册',
                  enable: loginEnable, onPressed: checkparams),
            )
          ],
        ),
      ),
    );
  }

//能不能提交检查
  void checkInput() {
    bool emable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      emable = true;
    } else {
      emable = false;
    }
    setState(() {
      loginEnable = emable;
    });
  }

  //提交注册检查
  void checkparams() {
    String tips;
    if (password != rePassword) {
      tips = "两次密码不一致";
    } else if (orderId.length != 4) {
      tips = "请输入订单号的后四位";
    }
    if (tips != null) {
      showWarnToast(tips);
      return;
    }
    //通过验证,发送请求
    send();
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(userName, password, imoocId, orderId);
      print("打印注册res:$result");
      if (result['code'] == 0) {
        showToast('注册成功');
        //这里添加跳转登录
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin();
        }
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}

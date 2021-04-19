import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          //ListView好处可以使键盘弹起
          children: [
            LoginInput(
              "用户名",
              "请输入用户名",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                print("得到输入框值$text");
              },
            )
          ],
        ),
      ),
    );
  }
}

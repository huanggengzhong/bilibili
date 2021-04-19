//登录输入框封装组件
import 'package:bilibili_app/util/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget {
  final String title; //标题
  final String hint; //提示语
  final ValueChanged<String> onChanged; //值改变事件
  final ValueChanged<bool> focusChanged; //是否获焦
  final bool lineStretch; //下线是否充满整行
  final bool obscureText; //是否密码框
  final TextInputType keboardType; //弹起的键盘类型

  const LoginInput(this.title, this.hint,
      {Key key,
      this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keboardType})
      : super(key: key); //输入框类型

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode(); //获取dom

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //获取光标的监听
    _focusNode.addListener(() {
      print("获取焦点了:${_focusNode.hasFocus}");
      if (widget.focusChanged != null) {
        widget.focusChanged(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Container(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          _input()
        ],
      ),
      Padding(
        padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
        child: Divider(
          height: 1,
          thickness: 0.5, //线的高度
        ),
      )
    ]);
  }

  Widget _input() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keboardType,
        autofocus: !widget.obscureText,
        cursorColor: primary,
        style: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
        //输入框的样式
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            border: InputBorder.none,
            hintText: widget.hint ?? '',
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
      ),
    );
  }
}

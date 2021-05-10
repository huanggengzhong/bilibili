import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer(
      {Key key, this.isLoading, this.cover = false, this.child})
      : super(key: key); //是否覆盖在原有界面上

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [child, isLoading ? _loadingView : Container()],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
    return Container();
  }

  Widget get _loadingView {
    return Center(
      child: Lottie.asset('assets/loading.json'),
    );
  }
}

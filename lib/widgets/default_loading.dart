import 'package:flutter/material.dart';
import 'package:shine_schedule/utils/colors.dart';

class Loading extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Color inactiveColor;
  final EdgeInsets? margin;
  final bool center;
  final double marginTop;
  final double marginBottom;
  const Loading(
      {Key? key,
      this.height = 40,
      this.width = 40,
      this.marginTop = 0,
      this.marginBottom = 0,
      this.color = ShineColors.appMainColor,
      this.inactiveColor = Colors.orangeAccent,
      this.margin,
      this.center = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        width: height,
        height: height,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ));
  }
}

class SmallLoading extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Color inactiveColor;
  final double marginTop;
  final double marginBottom;

  const SmallLoading(
      {Key? key,
      this.height = 40,
      this.width = 40,
      this.color = ShineColors.appMainColor,
      this.inactiveColor = Colors.white,
      this.marginTop = 0,
      this.marginBottom = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        width: height,
        height: height,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ));
  }
}

class FullScreenLoading extends StatelessWidget {
  final bool loading;
  const FullScreenLoading({Key? key, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white.withOpacity(.5),
            alignment: Alignment.center,
            child: const SmallLoading(),
          )
        : Container(width: 0);
  }
}

class CardLaoding extends StatelessWidget {
  final bool loading;
  const CardLaoding({Key? key, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(.3)),
              child: SmallLoading(),
            ))
        : Container();
  }
}

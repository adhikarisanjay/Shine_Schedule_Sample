import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastWidget(BuildContext context, Color backgroundColor, String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class CustomSnackBar {
  /// Show SnackBar
  void showSnakbar(BuildContext context, @required String message,
      @required SnackbarType barType) {
    final snackBar = SnackBar(
      content: CustomText(
        text: message,
        color: white,
      ),
      backgroundColor: (barType == SnackbarType.negative) ? red : Colors.green,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

CustomSnackBar customSnackBar = CustomSnackBar();

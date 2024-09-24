import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class CustomSnackBar {
  /// Show SnackBar
  void showSnakbar(BuildContext context, @required String message,
      @required SnackbarType barType) {
    final snackBar = SnackBar(
      //  width: 250,
      content: CustomContainer(
        width: 1.5,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              accountCreated,
              height: 20,
              width: 20,
            ),
            CustomSizedBox(
              width: 0.03,
            ),
            CustomText(
              text: message,
              color: white,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      backgroundColor: snackbarColor,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

CustomSnackBar customSnackBar = CustomSnackBar();

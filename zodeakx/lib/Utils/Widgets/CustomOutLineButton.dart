import 'package:flutter/material.dart';
import '../Core/ColorHandler/Colors.dart';
import 'CustomContainer.dart';
import 'CustomText.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final bool isBorderedButton;
  Color? borderColor;
  final double? width;
  final double? height;
  FontWeight? fontWeight;
  Color? color;
  Color? buttonColor;
  final VoidCallback? press;
  final double? borderWidth;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final double? fontSize;
  BorderRadiusGeometry? borderRadius;

  CustomOutlineButton(
      {Key? key,
        required this.text,
        required this.isBorderedButton,
        this.width,
        this.color,
        this.buttonColor,
        this.height,
        this.borderColor,
        this.press,
        this.fontWeight,
        this.borderRadius,
        this.borderWidth,
        this.end,
        this.begin,
        this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: CustomContainer(
        height: height ?? 50,
        width: width ?? 100,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: Border.all(
            color:themeColor,
            width:borderWidth ?? 0,
          ),
        ),
        child: Center(
          child: CustomText(
              fontfamily: "Poppins",
              text: text,
              align: TextAlign.center,
              color: color ?? white,
              fontsize: fontSize ?? 14,
              fontWeight: fontWeight ?? FontWeight.bold),
        ),
      ),
    );
  }
}

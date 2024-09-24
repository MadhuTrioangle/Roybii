import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text; // add text
  TextDecoration? decoration; // add decoration like TextDecoration.underline ,
  String? fontfamily; // add fontFamily like    fontFamily: "Roboto",
  FontStyle? fontStyle; // add fontStyle like  fontStyle: FontStyle.italic
  double? fontsize = 15.0; // add size in text
  int? maxlines; // add text maximum lines
  bool? softwrap; // wrap the text
  FontWeight? fontWeight =
      FontWeight.normal; // add fontWeight like normal, bold....
  Color? color ; // add text color
  TextOverflow? overflow =
      TextOverflow.visible; // add text overflow like  text ellipsis etc
  TextAlign? align; // used to align the text like center ,top,....
  final Function()? press; // used to add functionality on text
  final double? strutStyleHeight;
  final TextDecorationStyle? decorationStyle;
  final List<Shadow>? shadows;
  bool? shadow = false;
  double? height;

  CustomText(
      {Key? key,
      required this.text,
      this.fontsize,
      this.fontWeight,
      this.color,
      this.overflow,
      this.align,
      this.press,
      this.maxlines,
      this.softwrap,
      this.decoration,
      this.fontfamily,
      this.fontStyle,
      this.decorationStyle,
      this.strutStyleHeight,
      this.shadows,
      this.shadow,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Text(
        text,
        style: TextStyle(
          height: 1,
          fontFamily: fontfamily ?? 'InterTight',
          decoration: decoration,
          decorationStyle: decorationStyle,
          fontSize: fontsize,
          fontWeight: fontWeight,
          shadows: shadows,

          color: shadow == true ? Colors.transparent : color,
          overflow: overflow,
          fontStyle: fontStyle,
        ),
        textAlign: align,
        maxLines: maxlines,
        overflow: overflow,
        strutStyle: StrutStyle(
          height: strutStyleHeight,
        ),
      ),
    );
  }
}

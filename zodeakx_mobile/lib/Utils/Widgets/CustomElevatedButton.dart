import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNetworkImage.dart';

import '../Core/ColorHandler/Colors.dart';
import '../Core/ColorHandler/DarkandLightTheme.dart';
import 'CustomText.dart';

class CustomElevatedButton extends StatefulWidget {
  String text; //used for Button name
  final VoidCallback? press; //used for navigate

  final double radius; //used for button shape
  final bool isBorderedButton; //checking borderedButton or not
  final Color buttoncolor; //color for button
  final double height; //height for button
  final double width; //width for button
  double? fontSize; //width for button
  final int maxLines; //maximum lines in button
  final bool icons; //checking, button have icon or not
  final String? icon; // declare icon for button
  bool? shadow; // checking button have shadow or not
  final double? blurRadius; // around the button have blurRadius
  final double? spreadRadius; //  around the button have spreadRadius
  final Offset? offset;
  bool? multiClick = false;
  double? IconHeight ;
  Color color = Colors.black;
  Color? iconColor;
  FontWeight? fontWeight;
  Color? fillColor;


  CustomElevatedButton({
    Key? key,
    required this.text,
    this.press,
    required this.radius,
    required this.buttoncolor,
    required this.width,
    required this.height,
    this.fontSize,
    required this.isBorderedButton,
    required this.maxLines,
    required this.icons,
    required this.icon,
    this.IconHeight,
    this.multiClick,
    this.shadow,
    this.blurRadius,
    required this.color,
    this.spreadRadius,
    this.offset,
    this.iconColor,
    this.fontWeight,
    this.fillColor,

  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      clicked = false;
    });*/
    return GestureDetector(
      onTap: widget.multiClick == true
          ? widget.press
          : () async {
              if (clicked == false) {
                clicked = true;
                widget.press!();
              }
            },
      child: CustomContainer(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(

          border:Border.all(color: widget.buttoncolor,width :1),
          borderRadius: widget.isBorderedButton == true
              ? BorderRadius.circular(widget.radius)
              : BorderRadius.circular(widget.radius),
// widget.isBorderedButton == false?Color(0xF2F2F3) : Colors.transparent,
          color: widget.fillColor,

          // boxShadow: [
          //   themeSupport().isSelectedDarkMode()
          //       ? BoxShadow()
          //       : BoxShadow(
          //           color: buttomShadowColor,
          //           offset: widget.offset ?? Offset(0, 0), //(x,y)
          //           blurRadius: widget.blurRadius ?? 16,
          //           spreadRadius: widget.spreadRadius ?? 4,
          //         ),
          // ],
        ),

        child: Center(
          child: Center(
            child: widget.icons == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: SvgPicture.asset(widget.icon!,
                            color: widget.iconColor,
                            height: widget.IconHeight,

                        ),
                      ),
                      CustomText(
                        text: '  ${widget.text}',
                        color: widget.color,
                        overflow: TextOverflow.ellipsis,
                        fontsize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                : CustomText(
                    text: widget.text,
                    color: widget.color,
                    overflow: TextOverflow.ellipsis,
                    fontsize: widget.fontSize ?? 14,
                    fontWeight: widget.fontWeight ?? FontWeight.bold,
                  ),
          ),
        ),
      ),
    );
  }

  navigate(BuildContext context) {
    return CustomNetworkImage(
      image: 'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    );
  }
}

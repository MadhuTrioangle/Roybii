import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';

import 'CustomText.dart';

class CustomAppBar extends StatelessWidget {
  final double containerHeight; //declare height of the container
  final double containerWidth; // declare width of the container
  final double padding; // declare padding for space around the container
  final VoidCallback? prefixIconpress; // onpress function for prefixIcon
 // final VoidCallback? middleIconpress; //  onpress function for middleIcon
  final VoidCallback? suffixIconpress; //  onpress function for suffixIcon
  final String text; // heading

  final String prefixIcon; // prefixIcon Image name
  //final String middleIcon; // middleIcon Image name
  final String suffixIcon; // suffixIcon Image name
  final bool isPrefixIcon; // checking, button have prefixIcon or not
  //final bool isMiddleIcon; // checking, button have middleIcon or not
  final bool isSuffixIcon; // checking, button have suffixIcon or not
  final double prefixIconHeight; //declare heigth of the prefixIcon
  final double prefixIconWidth; //declare width of the prefixIcon
 // final double middleIconHeight; //declare heigth of the middleIcon
 // final double middleIconWidth; //declare width of the middleIcon
  final double suffixIconHeight; //declare heigth of the suffixIcon
  final double suffixIconWidth; //declare width of the suffixIcon
  final double fontSize; // declare fontSize

  final TextEditingController? textFormFieldController;
  final double textFormFieldSize;
  final bool textFormFieldcontentpadding;
  final Widget? textFormFieldPrefixIcon;
  final Widget? textFormFieldPSuffixIcon;
  final String? textFormFieldtext;
Color? fill;
  Color? circleFill;
  Color borderColor=Colors.redAccent;


  CustomAppBar(
      {Key? key,
      required this.containerHeight,
      required this.containerWidth,
      required this.prefixIconpress,

      required this.suffixIconpress,
      required this.text,
      required this.suffixIcon,
      required this.prefixIcon,

      required this.isPrefixIcon,
      required this.isSuffixIcon,

      required this.prefixIconHeight,
      required this.prefixIconWidth,

      required this.suffixIconHeight,
      required this.suffixIconWidth,
      required this.padding,
      required this.fontSize,

         this.textFormFieldPrefixIcon,
         this.textFormFieldPSuffixIcon,
         this.textFormFieldtext,
        this.textFormFieldController,
        required this.textFormFieldSize,
        required this.textFormFieldcontentpadding,
        this.fill,
        this.circleFill,
        required this.borderColor

      })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: CustomContainer(

        height: containerHeight,
        width: containerWidth,
        child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomContainer(
              height: 3,
              width: 10,
              // color: Colors.red,
              decoration: BoxDecoration(shape: BoxShape.circle,color: circleFill,border: Border.all(color:borderColor)),
              child: GestureDetector(
                  onTap: prefixIconpress,
                  child: SvgPicture.asset(
                    prefixIcon,
                    width: prefixIconWidth,
                    height: prefixIconHeight,
                  )),
            ),
            GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  '',
                  height: 0,
                  width: 0,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width / 35,//use big number to leave less space  width // if it is 8 long space
            ),
            CustomContainer(
              width: 5,
              child: CustomText(
                  fontfamily: 'InterTight',
                  text: text,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontsize: fontSize),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 60,
            ),
            CustomContainer(
              height: 22,
              width: 2,
              child: CustomTextFormField(
                  size: textFormFieldSize,
                  isContentPadding: textFormFieldcontentpadding,
                  controller: textFormFieldController,
                  prefixIcon: textFormFieldPrefixIcon,
                  text: textFormFieldtext,
                  suffixIcon: textFormFieldPSuffixIcon,
                  color: fill),
            ),
            // GestureDetector(
            //     onTap: middleIconpress,
            //     child: SvgPicture.asset(
            //       middleIcon,
            //       height: middleIconHeight,
            //       width: middleIconWidth,
            //     )),
            SizedBox(
              width: MediaQuery.of(context).size.width / 60,
            ),
            CustomContainer(
              height: 3,
              width: 10,
              // color: Colors.red,
              decoration: BoxDecoration(shape: BoxShape.circle,color: circleFill,border: Border.all(color:borderColor)),
              child: GestureDetector(
                  onTap: suffixIconpress,
                  child: SvgPicture.asset(
                    suffixIcon,
                    height: suffixIconHeight,
                    width: suffixIconWidth,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

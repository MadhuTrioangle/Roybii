import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';

import '../Core/ColorHandler/DarkandLightTheme.dart';

class CustomTextFormField extends StatelessWidget {
  double size = 15.0; // used to maintain size
  final Icon? iconData; // used to maintain icon
  FontWeight? fontWeight = FontWeight.normal;
  double? fontsize = 14.0; // maintain fontWeight of the text
  double? hintfontsize = 13.0; // maintain fontWeight of the text
  FontWeight? hintfontweight =
      FontWeight.w400; // maintain fontWeight of the text
  Color? color = Colors.black; // maintain border color
  String? text; // add text
  final String? Function(String?)? validator; // used to add validation
  final TextEditingController? controller; // used to control the text
  String? hint; // used for hinText
  final Widget? suffixIcon; // add widget
  final Widget? prefixIcon; // add widget
  final Function()? press; //  used to add functionality
  final bool? isBorderedButton;
  AutovalidateMode? autovalid;
  Key? keys;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry? contentPadding;
  int? minLines;
  int? maxLines;
  int? maxLength;
  FocusNode? focusNode;
  TextInputType? keyboardType;
  TextAlign? textAlign;
  FormFieldSetter<String>? onSaved;
  bool isContentPadding;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onFieldSubmit;
  final bool? isReadOnly;
  final Color? hintColor;
  final double? padLeft;
  final double? padRight;
  final bool? isBorder;


  // used to check obscure text
  CustomTextFormField(
      {Key? key,
      this.text,
      required this.size,
      this.suffixIcon,
      this.prefixIcon,
      this.validator,
      this.fontWeight,
      this.inputFormatters,
      this.color,
      this.hint,
      this.iconData,
      this.padLeft,
      this.padRight,
      this.controller,
      this.press,
      this.autovalid,
      this.textAlign,
      this.isBorderedButton,
      this.fontsize,
      this.maxLines,
      this.minLines,
      this.focusNode,
      this.keyboardType,
      this.onFieldSubmit,
      this.keys,
      this.onSaved,
      this.contentPadding,
      required this.isContentPadding,
      this.onChanged,
      this.isReadOnly,
      this.hintColor,
      this.hintfontsize,
      this.hintfontweight,
      this.maxLength,
      this.isBorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: (padLeft ?? 5.0), right: (padRight ?? 5)),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmit,
        //  enableInteractiveSelection: false,
        style: TextStyle(
          fontSize: fontsize ?? 14.0,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: themeSupport().isSelectedDarkMode() ? white : black,
        ),
        inputFormatters: inputFormatters,
        key: keys,
        onTap: press,
        readOnly: isReadOnly ?? false,
        focusNode: focusNode,
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        maxLength: maxLength ?? 300,
        onChanged: onChanged,
        onSaved: onSaved,
        cursorColor: themeColor,
        textAlignVertical: TextAlignVertical.center,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isBorderedButton == false,
        cursorWidth: 1,
        textAlign: textAlign ?? TextAlign.left,
        autovalidateMode: autovalid,
        decoration: InputDecoration(
          filled: color == null ? false : true,
          fillColor: color,
          counterText: '',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: isBorder == true
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size),
                  borderSide: const BorderSide(
                    width: 1.0,
                  ),
                ),
          errorBorder: isBorder == true
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size),
                  borderSide: BorderSide(color: red, width: 1.0),
                ),
          enabledBorder: isBorder == true
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
          focusedBorder: isBorder == true
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size),
                  borderSide: BorderSide(
                    color: themeColor,
                    width: 1.0,
                  ),
                ),
          hintText: text,
          errorStyle: TextStyle(color: red),
          errorMaxLines: 2,
          hintStyle: TextStyle(
              fontFamily: "InterTight",
              fontSize: hintfontsize ?? 13.0,
              color: hintColor,
              fontWeight: hintfontweight ?? FontWeight.w400),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: contentPadding ??
              ((isContentPadding == false)
                  ? EdgeInsets.only(left: 20.0, top: 0, bottom: 0, right: 20)
                  : EdgeInsets.only(left: 20, top: 30, bottom: 0, right: 20)),
          labelStyle: const TextStyle(
            fontFamily: 'InterTight',
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}

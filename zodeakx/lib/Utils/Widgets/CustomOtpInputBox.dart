import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

class CustomOtpInput extends StatefulWidget {
  final TextEditingController controller;
  final bool autoFocus;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onSubmitted;
  Function()? onTap;
  final String? Function(String?)? validator; // used to add validation
  CustomOtpInput(
      {Key? key,
      required this.controller,
      required this.autoFocus,
      this.onChanged,
      this.onSubmitted,
      this.onTap,
      this.validator})
      : super(key: key);

  @override
  State<CustomOtpInput> createState() => _CustomOtpInputState();
}

class _CustomOtpInputState extends State<CustomOtpInput> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 10,
      width: 8,
      child: SingleChildScrollView(
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,

          // validator:validator ,
          cursorWidth: 1,

          //inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-,.\\-|\\ ]')),
          ],
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 17.0,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),

          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.number,
          controller: widget.controller,

          maxLength: 1,
          cursorColor: themeColor,
          onTap: widget.onTap ?? (() {}),

          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 3, bottom: 1),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(
                  color: themeColor,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: DarkAndLightMode().outlineBorderColor,
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: DarkAndLightMode().hintColor),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              counterText: '',
              hintStyle: TextStyle(
                  color:
                      themeSupport().isSelectedDarkMode() ? white : hintLight,
                  fontSize: 23.0)),
          onChanged: widget.onChanged,
          //  onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}

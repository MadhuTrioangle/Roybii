import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  Color borderColor = Colors.black; // used for checkbox border color
  Color checkColor = Colors.black; //used for check the color in checkbox
  Color activeColor = Colors.black; // used for checkbox active color
  final bool checkboxState; // check the box is select or not
  final Function(bool?) toggleCheckboxState; // onchange function

  CustomCheckBox({
    Key? key,
    required this.checkboxState,
    required this.toggleCheckboxState,
    required this.checkColor,
    required this.borderColor,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: checkColor,
      activeColor: activeColor,
      value: checkboxState,
      onChanged: toggleCheckboxState,
      side: BorderSide(
        color: borderColor, //your desire colour here
        width: 1.5,
      ),
    );
  }
}

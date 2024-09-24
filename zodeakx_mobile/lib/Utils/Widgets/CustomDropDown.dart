import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';

import '../Core/ColorHandler/Colors.dart';
import 'CustomText.dart';

class CustomDropDown extends StatefulWidget {
  final String hintName;
  final List<String> MDPT;

  CustomDropDown({
    required this.hintName,
    required this.MDPT,
  });

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? dropdownvalue;

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List list) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    list.forEach((value) {
      dropDownItems.add(DropdownMenuItem<String>(
        value: value,
        child: CustomText(
            text: value,
            fontWeight: FontWeight.bold,
            color: textGrey,
            fontsize: 15),
      ));
    });

    return dropDownItems;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: CustomText(
                text: widget.hintName,
                fontWeight: FontWeight.bold,
                color: textGrey,
                fontsize: 15),
            value: dropdownvalue,
            isDense: true,
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue;
                constant.walletCurrency.value = dropdownvalue.toString();
              });
            },
            items: buildDropdownMenuItems(widget.MDPT),
          ),
        );
      },
    );
  }
}

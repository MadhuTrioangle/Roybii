import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../Core/ColorHandler/Colors.dart';
import '../Core/ColorHandler/DarkandLightTheme.dart';
import 'CustomText.dart';

class InputDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 1,
      color: Color(0xFF6F6F6F).withOpacity(0.75),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.done,
              fontsize: 16,
              fontWeight: FontWeight.w600,
              color: themeColor,
            ),
          ),
        ),
      ),
    );
  }
}

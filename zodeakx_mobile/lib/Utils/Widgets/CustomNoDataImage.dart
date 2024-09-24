import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';

import '../Core/ColorHandler/Colors.dart';
import '../Languages/English/StringVariables.dart';
import 'CustomSizedbox.dart';
import 'CustomText.dart';

class CustomNoDataImage extends StatelessWidget {
  const CustomNoDataImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSizedBox(
            height: 0.04,
          ),
          SvgPicture.asset(
            stakingNotFound,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'InterTight',
            fontsize: 20,
            fontWeight: FontWeight.bold,
            text: stringVariables.notFound,
            color: hintLight,
          ),
        ],
      ),
    );
  }
}

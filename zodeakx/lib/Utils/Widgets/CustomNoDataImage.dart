import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';

class CustomNoDataImage extends StatelessWidget {
  const CustomNoDataImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        noData,
      ),
    );
  }
}

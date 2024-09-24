import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';

import 'CustomText.dart';

class CustomListTileView extends StatelessWidget {
  final String? title; // title for listTile
  final String? subTitle; // subTitle for listTile
  final Function()? tapFunction; // onpress function for listTile
  final String? leading; // image used on leading

  CustomListTileView({
    Key? key,
    @required this.title,
    @required this.subTitle,
    this.tapFunction,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tapFunction,
      leading: SvgPicture.asset(
        "$leading",
        color: textGrey,
      ),
      title: CustomText(text: "$title", color: Colors.black),
      subtitle: CustomText(text: "$subTitle", color: Colors.black),
    );
  }
}

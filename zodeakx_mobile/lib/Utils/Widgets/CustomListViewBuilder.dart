import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'CustomText.dart';

class CustomListViewBuilder extends StatelessWidget {
  Widget Function(BuildContext, int) itemBuilder; // declare index and context
  final Axis? scrollDirection; // declare scrollable direction
  final ScrollPhysics physics; // declare direction
  final bool shrinkWrap; // checking shrinkwrap
  final int itemCount; // declare length
  final Widget? child; //return child
  final String? title; // title for listTile
  final String? subTitle; // subTitle for listTile
  final Function()? tapFunction; // onpress function for listTile
  final String? leading;

  CustomListViewBuilder({
    Key? key,
    required this.itemBuilder,
    this.scrollDirection,
    required this.physics,
    required this.shrinkWrap,
    required this.itemCount,
    this.child,
    @required this.title,
    @required this.subTitle,
    this.tapFunction,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemBuilder: (context, itemBuilder) {
          return ListTile(
            onTap: tapFunction,
            leading: SvgPicture.asset(
              "$leading",
              width: 30,
              height: 50,
            ),
            title: CustomText(text: "$title", color: Colors.red),
            subtitle: CustomText(text: "$subTitle", color: Colors.black),
          );
        });
  }
}

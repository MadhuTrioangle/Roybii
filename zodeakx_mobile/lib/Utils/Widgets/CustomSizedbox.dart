import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  double? height; // used to maintain height

  double? width; //used to maintain width
  Widget? child; // used to add widget
  CustomSizedBox({Key? key, this.height, this.width, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height:
          height != null ? MediaQuery.of(context).size.height * height! : 10.0,
      width: width != null ? MediaQuery.of(context).size.width * width! : 10.0,
      child: child,
    );
  }
}

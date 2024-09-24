import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import '../Constant/App_ConstantIcon.dart';
import '../Core/ColorHandler/Colors.dart';


class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height:  MediaQuery.of(context).size.height/50,
      width: 0.0,
      child: Center(
        child: Image.asset(
          loader,
          width: 75,
          height: 15,color: themeColor,
        ),
      ),
    );
  }
}
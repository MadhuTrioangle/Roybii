import 'package:flutter/material.dart';

import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';

class AppThemes {
  static final darkTheme = ThemeData(

    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: Colors.transparent,
      //selectionHandleColor: themeColor,

    ),
      scaffoldBackgroundColor: black,
      cardColor: Colors.white10 ,
      colorScheme: const ColorScheme.dark(),
      fontFamily: 'GoogleSans',

  );
  static final lightTheme = ThemeData(

      scaffoldBackgroundColor: grey,
      colorScheme: const ColorScheme.light(),
      hintColor: Colors.white ,
      cardColor: Colors.white,
  );
}
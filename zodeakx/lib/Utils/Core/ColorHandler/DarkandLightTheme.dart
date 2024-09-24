import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';

ValueNotifier<bool> darkTheme = ValueNotifier(false);
ValueNotifier<Brightness> checkBrightness = ValueNotifier(Brightness.dark);

class themeSupport extends ChangeNotifier {
  var userSelected;

  void init() async {
    constant.pref = await SharedPreferences.getInstance();
    userSelected = constant.pref?.getBool('userSelectedTheme') ?? false;
    checkBrightness.value = userSelected ? Brightness.dark : Brightness.light;
    checkBrightness.notifyListeners();
  }

  bool isSelectedDarkMode() {
    init();
    bool isDarkMode = checkBrightness.value == Brightness.dark;
    SchedulerBinding.instance.window.platformBrightness;
    return isDarkMode;
  }
}

// firs value dark theme 2. light theme
class DarkAndLightMode {
  Color backgroundColor = darkTheme.value ? black : grey;
  Color textColor = darkTheme.value ? textDark : textLight;
  Color hintColor = darkTheme.value ? white70 : hintLight;
  Color appThemeColor = darkTheme.value ? darkThemeColor : themeColor;
  Color outlineBorderColor = darkTheme.value ? white : enableBorder;
  Color containerColor = darkTheme.value ? black : white;
}

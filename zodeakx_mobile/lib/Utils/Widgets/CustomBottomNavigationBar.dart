import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Core/ColorHandler/Colors.dart';
import '../Core/ColorHandler/DarkandLightTheme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List icon;
  final List label;
  final double heigth;
  final Color color;
  final Color backgroundColor;
  final BoxFit fit;
  final ValueChanged<int>? onTabSelected;
  final dynamic? commonViewModel;

  CustomBottomNavigationBar(
      {Key? key,
      required this.icon,
      required this.label,
      required this.heigth,
      required this.color,
      required this.backgroundColor,
      this.onTabSelected,
      this.commonViewModel,
      required this.fit})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  BottomNavigationBarItem buildBottomNavBarItems(String icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          icon,
          color: textGrey,
          height: widget.heigth,
          fit: BoxFit.fill,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          icon,
          color: themeColor,
          height: widget.heigth,
          fit: BoxFit.fill,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateIndex(int index) {
      widget.onTabSelected!(index);
    }

    buildItems() {
      List<BottomNavigationBarItem> list = [];
      for (int i = 0; i < widget.icon.length; i++) {
        list.add(buildBottomNavBarItems(widget.icon[i], widget.label[i]));
      }
      return list;
    }

    return BottomNavigationBar(
        backgroundColor:
            checkBrightness.value == Brightness.dark ? darkScaffoldColor : grey,
        unselectedFontSize: 13,
        selectedFontSize: 13,
        selectedLabelStyle: TextStyle(
          fontFamily: 'InterTight',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'InterTight',
        ),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: textGrey,
        selectedItemColor: themeColor,
        currentIndex: widget.commonViewModel!.id,
        showUnselectedLabels: true,
        items: buildItems(),
        onTap: _updateIndex);
  }
}

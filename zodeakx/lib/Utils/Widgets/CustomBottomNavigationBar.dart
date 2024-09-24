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
  final int itemsCount;

  CustomBottomNavigationBar(
      {Key? key,
      required this.icon,
      required this.label,
      required this.heigth,
      required this.color,
      required this.backgroundColor,
      this.onTabSelected,
      this.commonViewModel,required this.itemsCount,
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

    return BottomNavigationBar(
        backgroundColor:
            checkBrightness.value == Brightness.dark ? Colors.black : grey,
        unselectedFontSize: 13,
        selectedFontSize: 13,
        selectedLabelStyle: TextStyle(
          fontFamily: 'GoogleSans',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'GoogleSans',
        ),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: textGrey,
        selectedItemColor: themeColor,
        currentIndex: widget.commonViewModel!.id,
        showUnselectedLabels: true,
        items: widget.itemsCount == 3 ? [
          buildBottomNavBarItems(widget.icon[0], widget.label[0]),
          buildBottomNavBarItems(widget.icon[1], widget.label[1]),
          buildBottomNavBarItems(widget.icon[2], widget.label[2]),
          // buildBottomNavBarItems(widget.icon[3], widget.label[3]),
        ] : [
          buildBottomNavBarItems(widget.icon[0], widget.label[0]),
          buildBottomNavBarItems(widget.icon[1], widget.label[1]),
          buildBottomNavBarItems(widget.icon[2], widget.label[2]),
          buildBottomNavBarItems(widget.icon[3], widget.label[3]),
        ],
        onTap: _updateIndex);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Core/ColorHandler/Colors.dart';
import 'CustomContainer.dart';
import 'CustomSizedbox.dart';

class CustomImageSlider extends StatefulWidget {
  final List<String> images;
  final PageController? pageController;
  final ValueChanged<int> onPageChanged;
  final int activePage;

  CustomImageSlider({
    Key? key,
    required this.images,
    required this.pageController,
    required this.onPageChanged,
    required this.activePage,
  }) : super(key: key);

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  Widget buildDot(int index, BuildContext context, int currentIndex) {
    return Row(
      children: [
        CustomContainer(
          height: 150,
          width: currentIndex == index ? 11 : 23,
          decoration: BoxDecoration(
            color: currentIndex == index ? themeColor : hintLight,
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        CustomSizedBox(
          width: 0.015,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomContainer(
          height: 2.3,
          width: 1,
          child: PageView.builder(
              padEnds: false,
              itemCount: widget.images.length,
              pageSnapping: true,
              controller: widget.pageController,
              onPageChanged: widget.onPageChanged,
              itemBuilder: (context, pagePosition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      widget.images[pagePosition],
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.images.length,
                (index) => buildDot(index, context, widget.activePage)),
          ),
        ),
      ],
    );
  }
}

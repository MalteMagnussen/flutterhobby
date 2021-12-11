import 'package:flutter/material.dart';

enum Direction { left, right }

class MyArrow extends StatelessWidget {
  const MyArrow({
    Key? key,
    required this.pageController,
    required this.direction,
  }) : super(key: key);

  Future<void> goToNextPage() {
    return pageController.nextPage(duration: duration(), curve: Curves.ease);
  }

  Future<void> goToPreviousPage() {
    return pageController.previousPage(
        duration: duration(), curve: Curves.ease);
  }

  Duration duration() => const Duration(milliseconds: 300);
  final PageController pageController;
  final Direction direction;
  final double padding = 15;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: direction == Direction.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Padding(
          padding: direction == Direction.right
              ? EdgeInsets.only(right: padding)
              : EdgeInsets.only(left: padding),
          child: IconButton(
            iconSize: 30,
            // TODO - Make larger on-hover
            icon: Icon(direction == Direction.right
                ? Icons.arrow_forward_ios
                : Icons.arrow_back_ios),
            onPressed: () {
              direction == Direction.right
                  ? goToNextPage()
                  : goToPreviousPage();
            },
          ),
        ),
      ),
    );
  }
}

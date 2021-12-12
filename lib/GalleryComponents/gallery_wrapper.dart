import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterhobby/GalleryComponents/page_view_arrow.dart';

import 'gallery_keyboard_shortcuts.dart';

class GalleryWrapper extends StatefulWidget {
  const GalleryWrapper({
    Key? key,
    required this.pageController,
    required this.length,
    required this.pageViewItemBuilder,
  }) : super(key: key);

  final PageController pageController;
  final int length;
  final Function pageViewItemBuilder;

  @override
  _GalleryWrapperState createState() => _GalleryWrapperState();
}

class _GalleryWrapperState extends State<GalleryWrapper> {
  @override
  Widget build(BuildContext context) {
    return GalleryKeyboardShortcuts(
      pageController: widget.pageController,
      child: Focus(
        autofocus: true,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: widget.pageController,
              allowImplicitScrolling: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.length == 0 ? null : widget.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.pageViewItemBuilder(
                  index.toDouble(),
                  widget.length,
                );
              },
            ),
            MyArrow(
              pageController: widget.pageController,
              direction: Direction.left,
            ),
            MyArrow(
              pageController: widget.pageController,
              direction: Direction.right,
            ),
          ],
        ),
      ),
    );
  }
}

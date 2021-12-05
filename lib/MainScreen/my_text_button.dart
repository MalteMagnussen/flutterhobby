import 'dart:html' as html;

import 'package:flutter/material.dart';

class MyTextButton extends StatefulWidget {
  const MyTextButton({
    Key? key,
    required this.url,
    required this.text,
    required this.image,
  }) : super(key: key);

  final String image;
  final String url;
  final String text;

  final Shadow shadow = const Shadow(
    color: Colors.black,
    blurRadius: 10,
    offset: Offset(0, 0),
  );

  @override
  State<MyTextButton> createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {},
      mouseCursor: SystemMouseCursors.basic,
      onHover: (hovering) => {
        setState(() {
          this.hovering = hovering;
        })
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        height: hovering ? 60 : 40,
        child: TextButton.icon(
          icon: SizedBox(
            child: Image(
              image: AssetImage(widget.image),
            ),
          ),
          label: Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              shadows: [widget.shadow],
            ),
            textScaleFactor: 1.5,
          ),
          onPressed: () => html.window.open(widget.url, ""),
        ),
      ),
    );
  }
}

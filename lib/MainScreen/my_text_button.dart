import 'dart:html' as html;

import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    Key? key,
    required this.url,
    required this.text,
    required this.image,
  }) : super(key: key);

  final String image;
  final String url;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: SizedBox(
        width: 40,
        height: 40,
        child: Image(
          image: AssetImage(image),
        ),
      ),
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
        textScaleFactor: 1.5,
      ),
      onPressed: () => html.window.open(url, ""),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:html' as html;

class Label extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;

  const Label({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
  }) : super(key: key);

  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: AnimatedContainer(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        child: Card(
          child: ListTile(
            onTap: () => html.window.open(widget.image, ""),
            horizontalTitleGap: 10,
            leading: const Icon(
              Icons.download,
            ),
            mouseCursor: SystemMouseCursors.click,
            title: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

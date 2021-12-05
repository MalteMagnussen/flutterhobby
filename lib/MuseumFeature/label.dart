import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'artwork.dart';

class MuseumLabelWidget extends StatefulWidget {
  final Artwork artwork;

  const MuseumLabelWidget({
    Key? key,
    required this.artwork,
  }) : super(key: key);

  @override
  _MuseumLabelWidgetState createState() => _MuseumLabelWidgetState();
}

class _MuseumLabelWidgetState extends State<MuseumLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
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
            onTap: () => html.window.open(widget.artwork.primaryImage, ""),
            horizontalTitleGap: 10,
            leading: const Icon(
              Icons.download,
              semanticLabel: "Download this Painting.",
            ),
            mouseCursor: SystemMouseCursors.click,
            title: Text(
              widget.artwork.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Text(
              "${widget.artwork.artistDisplayName}"
              "\n${widget.artwork.objectDate}",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

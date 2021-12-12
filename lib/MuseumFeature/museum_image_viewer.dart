import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MuseumImageViewer extends StatelessWidget {
  const MuseumImageViewer({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;
  final double imageZoomScale = 10;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: imageZoomScale,
      child: Stack(children: <Widget>[
        const Center(child: CircularProgressIndicator()),
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: imageUrl,
            key: Key(imageUrl),
          ),
        ),
      ]),
    );
  }
}

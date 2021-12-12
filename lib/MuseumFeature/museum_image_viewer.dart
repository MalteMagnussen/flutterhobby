import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'artwork.dart';

class MuseumImageViewer extends StatelessWidget {
  const MuseumImageViewer({
    Key? key,
    required this.artwork,
  }) : super(key: key);

  final Artwork artwork;
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
            image: artwork.primaryImage,
            key: Key(artwork.objectID.toString()),
          ),
        ),
      ]),
    );
  }
}

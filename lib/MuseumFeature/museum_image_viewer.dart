import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MuseumImageViewer extends StatelessWidget {
  const MuseumImageViewer({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;
  final double imageZoomScale = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        fadeOutDuration: const Duration(milliseconds: 0),
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: imageUrl,
        key: Key(imageUrl),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

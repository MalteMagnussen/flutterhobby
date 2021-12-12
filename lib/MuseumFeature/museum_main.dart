import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhobby/GalleryComponents/gallery_wrapper.dart';
import 'package:flutterhobby/GalleryComponents/label.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:html' as html;

import '../GalleryComponents/gallery_keyboard_shortcuts.dart';
import '../GalleryComponents/page_view_arrow.dart';
import '../drawer.dart';
import 'artwork.dart';
import 'artwork_fetch.dart';
import 'package:flutter/foundation.dart';

import 'museum_image_viewer.dart';

class MuseumWidget extends StatefulWidget {
  const MuseumWidget({Key? key}) : super(key: key);

  @override
  _MuseumWidgetController createState() => _MuseumWidgetController();
}

class _MuseumWidgetController extends State<MuseumWidget> {
  late Future<List<int>> ids;
  String search = "Rembrandt van Rijn";
  late Future<Artwork> art;

  final isWebMobile = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  final List<String> famousEuropeanPainters = [
    "Random paintings",
    'Vincent van Gogh',
    // "Claude Monet",
    // "Pablo Picasso",
    "Pierre Auguste Renoir",
    // "Michelangelo Buonarroti",
    "Rembrandt van Rijn",
    "Andreas Achenbach",
    "Jean-Baptiste Pillement",
    "George Seurat",
    "Johannes Vermeer",
    "Michelangelo Merisi da Caravaggio",
    "Edgar Degas",
    "Eugène Delacroix",
    "Anthony Van Dyck",
    "Thomas Gainsborough",
    "Paul Gauguin",
    "Alphonse-Marie-Adolphe de Neuville",
    "Diego Velázquez",
    // "Leonardo da Vinci",
    // "Raphael Sanzio da Urbino",
  ];

  final PageController pageController = PageController(
    keepPage: true,
    initialPage: 0,
  );

  @override
  void initState() {
    ids = fetchPaintingsIds(search);
    art = getArtwork(0);
    super.initState();
  }

  Future<Artwork> getArtwork(double _id) async {
    List<int> _ids = await ids;
    int id = _id.toInt();
    Future<Artwork> _art = fetchArtwork(_ids.elementAt(id));
    return _art;
  }

  Duration duration() => const Duration(milliseconds: 300);

  void setDropDownValue(String newValue) {
    if (search == newValue) return;
    setState(() {
      search = newValue;
      ids = fetchPaintingsIds(search);
      pageController.animateToPage(
        0,
        duration: duration(),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) => _MuseumWidgetView(this);
}

class _MuseumWidgetView
    extends WidgetView<MuseumWidget, _MuseumWidgetController> {
  const _MuseumWidgetView(_MuseumWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HobbyNavigation(),
      appBar: AppBar(
        title: DropdownButton(
          isDense: false,
          value: state.search,
          onChanged: (String? newValue) {
            state.setDropDownValue(newValue!);
          },
          items: state.famousEuropeanPainters.map(
            (String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<int>>(
            future: state.ids,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                int length = snapshot.data!.length;
                return GalleryWrapper(
                  pageController: state.pageController,
                  length: length,
                  pageViewItemBuilder: buildImage,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  FutureBuilder<Artwork> buildImage(double index, int length) {
    return FutureBuilder<Artwork>(
      future: state.getArtwork(index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Artwork artwork = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LabelWidget(
                title: artwork.title,
                subtitle: "${artwork.artistDisplayBio}\n${artwork.objectDate}",
                image: artwork.primaryImage,
              ),
              Expanded(
                child: MuseumImageViewer(artwork: artwork),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "\n${index + 1} of $length",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhobby/GalleryComponents/label.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:html' as html;

import '../GalleryComponents/galleryKeyboardShortcuts.dart';
import '../GalleryComponents/pageViewArrow.dart';
import '../drawer.dart';
import 'artwork.dart';
import 'artwork_fetch.dart';
import 'package:flutter/foundation.dart';

// TODO - Move widgets to separate files.

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

class NextPageIntent extends Intent {
  const NextPageIntent();
}

class PreviousPageIntent extends Intent {
  const PreviousPageIntent();
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
                return GalleryKeyboardShortcuts(
                  pageController: state.pageController,
                  child: Focus(
                    autofocus: true,
                    child: Stack(
                      children: <Widget>[
                        PageView.builder(
                          controller: state.pageController,
                          allowImplicitScrolling: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildImage(index.toDouble(), length);
                          },
                        ),
                        if (!state.isWebMobile)
                          MyArrow(
                            pageController: state.pageController,
                            direction: Direction.left,
                          ),
                        if (!state.isWebMobile)
                          MyArrow(
                            pageController: state.pageController,
                            direction: Direction.right,
                          ),
                      ],
                    ),
                  ),
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
                child: MuseumImageViewer(state: state, artwork: artwork),
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

class MuseumImageViewer extends StatelessWidget {
  const MuseumImageViewer({
    Key? key,
    required this.state,
    required this.artwork,
  }) : super(key: key);

  final _MuseumWidgetController state;
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

class MyShimmer extends StatelessWidget {
  const MyShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(decoration: const BoxDecoration(color: Colors.black12)),
      baseColor: Colors.black12,
      highlightColor: Colors.white,
    );
  }
}

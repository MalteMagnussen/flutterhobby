import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shimmer/shimmer.dart';

import '../drawer.dart';
import 'artwork.dart';
import 'artwork_fetch.dart';

class MuseumWidget extends StatefulWidget {
  const MuseumWidget({Key? key}) : super(key: key);

  @override
  _MuseumWidgetController createState() => _MuseumWidgetController();
}

class _MuseumWidgetController extends State<MuseumWidget> {
  late Future<List<int>> ids;
  String search = "Rembrandt van Rijn";
  late Future<Artwork> art;
  final double imageZoomScale = 10;

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
    //"Leonardo da Vinci",
    //"Raphael Sanzio da Urbino",
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

  void setDropDownValue(String newValue) {
    if (search == newValue) return;
    setState(() {
      search = newValue;
      ids = fetchPaintingsIds(search);
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) => _MuseumWidgetView(this);
}

class _MuseumWidgetView
    extends WidgetView<MuseumWidget, _MuseumWidgetController> {
  _MuseumWidgetView(_MuseumWidgetController state) : super(state);

  late MediaQueryData media;

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context);
    bool isScreenWide = media.size.width > media.size.height;
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
                return PageView.builder(
                  controller: state.pageController,
                  allowImplicitScrolling: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildImage(index.toDouble(), length, isScreenWide);
                  },
                );
              } else {
                return const MyShimmer();
              }
            },
          ),
        ),
      ),
    );
  }

  FutureBuilder<Artwork> buildImage(
      double index, int length, bool isScreenWide) {
    return FutureBuilder<Artwork>(
      future: state.getArtwork(index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Artwork artwork = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        artwork.title,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                          "${artwork.artistDisplayName}"
                          "\n${artwork.objectDate}",
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  maxScale: state.imageZoomScale,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: artwork.primaryImage,
                    key: Key(index.toString()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("\n${index + 1} of $length"),
              )
            ],
          );
        }
        return const MyShimmer();
      },
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

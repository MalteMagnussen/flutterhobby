import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';

import '../drawer.dart';
import 'artwork.dart';
import 'artwork_fetch.dart';

class MuseumWidget extends StatefulWidget {
  @override
  _MuseumWidgetController createState() => _MuseumWidgetController();
}

class _MuseumWidgetController extends State<MuseumWidget> {
  late Future<List<int>> ids;
  late int id;
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
    id = 0;
    art = onPageChanged(id);
    super.initState();
  }

  Future<Artwork> getPainting() async {
    List<int> _ids = await ids;
    Future<Artwork> _art = fetchArtwork(_ids.elementAt(id));
    return _art;
  }

  void setDropDownValue(String newValue) {
    if (search == newValue) return;
    setState(() {
      search = newValue;
      ids = fetchPaintingsIds(search);
      onPageChanged(0);
    });
  }

  Future<Artwork> onPageChanged(int _id) async {
    setState(() {
      id = _id;
      art = getPainting();
    });
    return art;
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
      endDrawer: HobbyNavigation(),
      appBar: AppBar(
        title: const Text("Swipe Art from The Metropolitan Museum of Art"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flex(
                direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 8,
                        bottom: 8,
                      ),
                      child: DropdownButton(
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
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          child: FutureBuilder<Artwork>(
                            future: state.art,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Artwork artwork = snapshot.data!;
                                return ListTile(
                                  title: Text(
                                    artwork.title,
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                      "${artwork.artistDisplayName}"
                                      "\n${artwork.objectDate}",
                                      textAlign: TextAlign.center),
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<int>>(
                  future: state.ids,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      int length = snapshot.data!.length;
                      return Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: state.pageController,
                              allowImplicitScrolling: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: length,
                              onPageChanged: (value) =>
                                  state.onPageChanged(value),
                              itemBuilder: (BuildContext context, int index) {
                                return buildImage(index);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("\n${state.id + 1} of ${length + 1}"),
                          )
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<Artwork> buildImage(int index) {
    return FutureBuilder<Artwork>(
      future: state.onPageChanged(index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Artwork artwork = snapshot.data!;
          return InteractiveViewer(
            maxScale: state.imageZoomScale,
            child: Image.network(
              artwork.primaryImage,
              key: Key(index.toString()),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

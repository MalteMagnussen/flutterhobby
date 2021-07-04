import 'dart:math';

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

  final PageController pageController = PageController(
    keepPage: true,
    initialPage: 0,
  );

  @override
  void initState() {
    ids = fetchPaintingsIds("\"\"");
    super.initState();
  }

  Future<Artwork> getPainting(int index) async {
    List<int> _ids = await ids;
    return await fetchArtwork(_ids.elementAt(index));
  }

  @override
  Widget build(BuildContext context) => _MuseumWidgetView(this);
}

class _MuseumWidgetView
    extends WidgetView<MuseumWidget, _MuseumWidgetController> {
  _MuseumWidgetView(_MuseumWidgetController state) : super(state);
// TODO - Let user search or something.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HobbyNavigation(),
      appBar: AppBar(
        title: const Text("Swipe Art from The Metropolitan Museum of Art"),
      ),
      body: Center(
        child: PageView.builder(
          controller: state.pageController,
          allowImplicitScrolling: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return buildImage(index);
          },
        ),
      ),
    );
  }

  FutureBuilder<Artwork> buildImage(int index) {
    return FutureBuilder<Artwork>(
      future: state.getPainting(index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Artwork artwork = snapshot.data!;
          return Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
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
                  maxScale: 5.0,
                  child: Image.network(
                    artwork.primaryImage,
                    key: Key(index.toString()),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

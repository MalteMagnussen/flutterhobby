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
    initialPage: 1,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HobbyNavigation(),
        appBar: AppBar(
          title: const Text("Explore Art"),
        ),
        body: Center(
          child: FutureBuilder<List<int>>(
            future: state.ids,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return PageView.builder(
                  controller: state.pageController,
                  allowImplicitScrolling: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return buildImage(index);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }

  FutureBuilder<Artwork> buildImage(int id) {
    return FutureBuilder<Artwork>(
      future: state.getPainting(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network(
            snapshot.data!.primaryImage,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const CircularProgressIndicator();
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

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
  late Future<Artwork> artwork;
  Random random = Random();

  @override
  void initState() {
    artwork = randomImage();
    super.initState();
  }

  Future<bool> evictImage(String imageURL) async {
    final NetworkImage provider = NetworkImage(imageURL);
    return await provider.evict();
  }

  Future<int> getRandomImageID([String search = "\"\""]) async {
    List<int> ids = await fetchPaintingsIds(search);
    return ids.elementAt(random.nextInt(ids.length - 1));
  }

  Future<Artwork> randomImage() async {
    Artwork art = await fetchArtwork(
      await getRandomImageID(),
    );
    return art;
  }

  void newRandomImage() {
    setState(() {
      artwork = randomImage();
    });
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
        child: FutureBuilder<Artwork>(
          future: state.artwork,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.done) {
              return InkWell(
                onTap: state.newRandomImage,
                child: Image.network(snapshot.data!.primaryImage,
                    loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                }),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

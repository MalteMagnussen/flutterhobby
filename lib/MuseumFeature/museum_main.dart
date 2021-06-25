import 'dart:math';
import 'dart:typed_data';

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
  late Artwork art;
  late Uint8List bytes;
  late bool loadingImage;
  late int imageId;
  Random random = Random();

  @override
  void initState() {
    imageId = 437980;
    super.initState();
  }

  Future<int> getRandomImageID([String search = "\"\""]) async {
    List<int> ids = await fetchPaintingsIds(search);
    return random.nextInt(ids[ids.length]);
  }

  void randomImage() async {
    Artwork _tempArt = await fetchArtwork(
      await getRandomImageID(),
    );
    setState(() {
      art = _tempArt;
    });
  }

  Future<String> getArt(int id) async {
    Artwork _tempArt = await fetchArtwork(id);
    print(_tempArt.primaryImage);
    return _tempArt.primaryImage;
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
        child: FutureBuilder<String>(
          future: state.getArt(state.imageId),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  return InkWell(
                      onTap: () {
                        state.randomImage();
                      },
                      child: Image.network(snapshot.data!));
                }
            }
            return Text("Something went wrong.");
          },
        ),
      ),
    );
  }
}

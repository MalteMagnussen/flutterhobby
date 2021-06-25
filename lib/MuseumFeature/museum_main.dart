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

  @override
  void initState() {
    super.initState();
  }

  Future<String> getArt2(int id) async {
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
          future: state.getArt2(49257),
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
                  return Image.network(snapshot.data!);
                }
            }
            return Text("Something went wrong.");
          },
        ),
      ),
    );
  }
}

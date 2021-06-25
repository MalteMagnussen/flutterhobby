import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<Uint8List> getArt(int id) async {
    Artwork _tempArt = await fetchArtwork(id);
    print(_tempArt.primaryImage);
    ByteData imageData = await NetworkAssetBundle(
      Uri.parse(_tempArt.primaryImage),
    ).load("");
    print(imageData);
    Uint8List _bytes = imageData.buffer.asUint8List();
    print(_bytes);
    setState(() {
      art = _tempArt;
      bytes = _bytes;
    });
    return _bytes;
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
        child: FutureBuilder<Uint8List>(
          future: state.getArt(49257),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  return Image.memory(state.bytes);
                }
            }
            return Text("Something went wrong.");
          },
        ),
      ),
    );
  }
}

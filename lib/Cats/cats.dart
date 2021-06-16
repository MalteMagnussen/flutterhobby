import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../drawer.dart';

class CatWidget extends StatefulWidget {
  const CatWidget({Key? key}) : super(key: key);
  @override
  _CatWidgetController createState() => _CatWidgetController();
}

class _CatWidgetController extends State<CatWidget> {
  @override
  Widget build(BuildContext context) => _CatWidgetView(this);
}

class _CatWidgetView extends WidgetView<CatWidget, _CatWidgetController> {
  const _CatWidgetView(_CatWidgetController state) : super(state);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HobbyNavigation(),
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.pushNamed(context, '/'),
          child: const Text("Malte Hviid-Magnussen - Hobby Projects"),
        ),
      ),
      body: Center(
        // TODO - https://www.youtube.com/watch?v=QzA4c4QHZCY
        child: Stack(alignment: Alignment.center, children: const <Widget>[
          CatImageWidget(distance: 4.0, elevation: 4.0),
          CatImageWidget(distance: 12.0, elevation: 8.0),
          CatImageWidget(distance: 20.0, elevation: 12.0)
        ]),
      ),
    );
  }
}

class CatImageWidget extends StatefulWidget {
  final double distance;
  final double elevation;
  const CatImageWidget(
      {Key? key, required this.distance, required this.elevation})
      : super(key: key);
  @override
  _CatImageWidgetController createState() => _CatImageWidgetController();
}

class _CatImageWidgetController extends State<CatImageWidget> {
  final baseCatUrl = "https://cataas.com/cat";
  String catUrl =
      "https://cataas.com/cat?v=${DateTime.now().millisecondsSinceEpoch}";

  Future<bool> evictImage(String imageURL) async {
    final NetworkImage provider = NetworkImage(imageURL);
    return await provider.evict();
  }

  void clearImageCache() async {
    setState(() {
      catUrl = "$baseCatUrl?v=${DateTime.now().millisecondsSinceEpoch}";
    });
    imageCache!.clear();
    imageCache!.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) => _CatImageWidgetView(this);
}

class _CatImageWidgetView
    extends WidgetView<CatImageWidget, _CatImageWidgetController> {
  const _CatImageWidgetView(_CatImageWidgetController state) : super(state);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: state.widget.distance,
      child: Card(
        elevation: state.widget.elevation,
        child: InkWell(
          // TODO - Remove InkWell and onTap once we have the draggable feature implemented.
          onTap: () {
            state.clearImageCache();
          },
          child: Container(
            height: 400,
            width: 320,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://cataas.com/cat?v=${DateTime.now().millisecondsSinceEpoch}")),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}

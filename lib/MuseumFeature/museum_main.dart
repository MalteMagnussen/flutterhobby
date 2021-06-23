import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';

class MuseumWidget extends StatefulWidget {
  @override
  _MuseumWidgetController createState() => _MuseumWidgetController();
}

class _MuseumWidgetController extends State<MuseumWidget> {
  @override
  Widget build(BuildContext context) => _MuseumWidgetView(this);
}

class _MuseumWidgetView
    extends WidgetView<MuseumWidget, _MuseumWidgetController> {
  _MuseumWidgetView(_MuseumWidgetController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Here will be a museum feature, "
        "\nusing art from https://metmuseum.github.io/",
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HobbyNavigation extends StatefulWidget {
  const HobbyNavigation({Key? key}) : super(key: key);

  @override
  _HobbyNavigationController createState() => _HobbyNavigationController();
}

class _HobbyNavigationController extends State<HobbyNavigation> {
  final Map<String, String> navigationInfo = {
    "Front Page": "/",
    "Swipe Museum Art": "/museum",
    "NASA Astronomy Picture of the Day": "/nasa",
    //"Guess your age": "/guessage",
    // "Sort your photos": "/imagesorting",
  };

  @override
  Widget build(BuildContext context) => _HobbyNavigationView(this);
}

class _HobbyNavigationView
    extends WidgetView<HobbyNavigation, _HobbyNavigationController> {
  _HobbyNavigationView(_HobbyNavigationController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        controller: ScrollController(),
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(''),
          ),
          ListTile(
            title: const Text(
              "Front Page",
              textScaleFactor: 1.5,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),
          ListTile(
            title: const Text(
              "Museum Art",
              textScaleFactor: 1.5,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/museum");
            },
            subtitle: const Text("Swipe art from the MET"),
          ),
          ListTile(
            title: const Text(
              "NASA",
              textScaleFactor: 1.5,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/nasa");
            },
            subtitle: const Text(
              'Astronomy Picture of the Day',
              style: TextStyle(fontSize: 12),
            ),
          ),
          ListTile(
            onTap: () => launch("https://astokholm.github.io/"),
            title: const Text(
              "CV Website",
              textScaleFactor: 1.5,
            ),
            subtitle: const Text(
              'I made this for a friend.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

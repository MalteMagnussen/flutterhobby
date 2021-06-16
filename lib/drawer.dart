import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';

class HobbyNavigation extends StatefulWidget {
  @override
  _HobbyNavigationController createState() => _HobbyNavigationController();
}

class _HobbyNavigationController extends State<HobbyNavigation> {
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
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(''),
          ),
          ListTile(
            title: const Text(
              'Front Page',
              textScaleFactor: 1.5,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: const Text(
              'Guess Your Age',
              textScaleFactor: 1.5,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/guessage');
            },
          ),
          ListTile(
            title: const Text(
              'Cats',
              textScaleFactor: 1.5,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/cats');
            },
          ),
        ],
      ),
    );
  }
}

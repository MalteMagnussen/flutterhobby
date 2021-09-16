import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';

class HobbyNavigation extends StatefulWidget {
  const HobbyNavigation({Key? key}) : super(key: key);

  @override
  _HobbyNavigationController createState() => _HobbyNavigationController();
}

class _HobbyNavigationController extends State<HobbyNavigation> {
  final Map<String, String> navigationInfo = {
    "Front Page": "/",
    "Swipe Museum Art": "/museum",
    "Guess your age": "/guessage",
    "Sort your photos": "/imagesorting",
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
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(''),
          ),
          for (String key in state.navigationInfo.keys)
            DrawerListTile(
              navigationPath: state.navigationInfo[key],
              navigationText: key,
            ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.navigationPath,
    required this.navigationText,
  }) : super(key: key);

  final String navigationText;
  final String? navigationPath;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        navigationText,
        textScaleFactor: 1.5,
      ),
      onTap: () {
        Navigator.pushNamed(context, navigationPath!);
      },
    );
  }
}

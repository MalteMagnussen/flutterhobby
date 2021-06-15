import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../drawer.dart';

class MalteSocials extends StatefulWidget {
  @override
  _MalteSocialsController createState() => _MalteSocialsController();
}

class _MalteSocialsController extends State<MalteSocials> {
  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) => _MalteSocialsView(this);
}

class _MalteSocialsView
    extends WidgetView<MalteSocials, _MalteSocialsController> {
  _MalteSocialsView(_MalteSocialsController state) : super(state);
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 150,
                  backgroundImage: const Image(
                    image: AssetImage("assets/malte.jpg"),
                  ).image,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Malte Hviid-Magnussen',
                  textScaleFactor: 4,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Flutter. Sailing.\nBouldering. DevOps.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textScaleFactor: 2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  icon: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Image(
                      image: AssetImage("assets/GitHub-Mark-Light-64px.png"),
                    ),
                  ),
                  label: Text(
                    'GitHub',
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () =>
                      state._launchURL("https://github.com/MalteMagnussen"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  icon: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Image(
                      image: AssetImage("assets/LI-In-Bug.png"),
                    ),
                  ),
                  label: Text(
                    'LinkedIn',
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () => state._launchURL(
                      "https://www.linkedin.com/in/maltemagnussen/"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

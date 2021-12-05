import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';

import '../drawer.dart';
import 'my_text_button.dart';

class MalteSocials extends StatefulWidget {
  const MalteSocials({Key? key}) : super(key: key);

  @override
  _MalteSocialsController createState() => _MalteSocialsController();
}

class _MalteSocialsController extends State<MalteSocials> {
  final ScrollController _controller = ScrollController();
  String malteText = 'Flutter. Sailing.\nSecurity. DevOps.';

  @override
  Widget build(BuildContext context) => _MalteSocialsView(this);
}

class _MalteSocialsView
    extends WidgetView<MalteSocials, _MalteSocialsController> {
  const _MalteSocialsView(_MalteSocialsController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HobbyNavigation(),
      appBar: AppBar(
        title: const Text(
          "Swipe in Menu from the right",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: state._controller,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    alignment: AlignmentDirectional.topCenter,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "https://i.imgur.com/a5778wA.jpg",
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(
                          'Malte Hviid-Magnussen',
                          textScaleFactor: 4,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                            shadows: [
                              const Shadow(
                                color: Colors.black,
                                blurRadius: 6,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          state.malteText,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                            shadows: [
                              const Shadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          textScaleFactor: 2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const MyTextButton(
                          text: "GitHub",
                          image: "assets/GitHub-Mark-Light-64px.png",
                          url: "https://github.com/MalteMagnussen",
                        ),
                        const SizedBox(height: 20),
                        const MyTextButton(
                          text: "LinkedIn",
                          image: "assets/LI-In-Bug.png",
                          url: "https://www.linkedin.com/in/maltemagnussen/",
                        ),
                        const SizedBox(height: 900),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

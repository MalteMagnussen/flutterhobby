import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterhobby/MainScreen/profile_picture.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../drawer.dart';
import 'my_text_button.dart';

// TODO Add gallery

class MalteSocials extends StatefulWidget {
  const MalteSocials({Key? key}) : super(key: key);

  @override
  _MalteSocialsController createState() => _MalteSocialsController();
}

class _MalteSocialsController extends State<MalteSocials> {
  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  final ScrollController _controller = ScrollController();
  String malteText = 'Flutter. Sailing.\nSecurity. DevOps.';

  Offset offset = const Offset(0, 0);

  void updateMousePosition(e) {
    setState(() => offset = e.localPosition);
  }

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
        child: MouseRegion(
          onHover: (e) => state.updateMousePosition(e),
          child: SingleChildScrollView(
            controller: state._controller,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // TODO - Make this a Cursor Blending https://wilsonwilson.dev/articles/flutter-hover-effect-triggers-the-definitive-guide/
                      alignment: AlignmentDirectional.topCenter,
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        "https://i.imgur.com/F2G4aJW.jpg",
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Transform.translate(
                            offset: state.offset,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 60,
                              ),
                              const ProfilePicture(),
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
                                state.malteText,
                                style: Theme.of(context).textTheme.bodyText1,
                                textScaleFactor: 2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const MyTextButton(
                                text: "GitHub",
                                image: "assets/GitHub-Mark-Light-64px.png",
                                url: "https://github.com/MalteMagnussen",
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const MyTextButton(
                                text: "LinkedIn",
                                image: "assets/LI-In-Bug.png",
                                url:
                                    "https://www.linkedin.com/in/maltemagnussen/",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CachedNetworkImage(
                  // TODO - Make this a perspective animation https://wilsonwilson.dev/articles/flutter-hover-effect-triggers-the-definitive-guide/
                  imageUrl: "https://i.imgur.com/a5778wA.jpg",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

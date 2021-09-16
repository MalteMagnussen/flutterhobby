import 'package:flutter/material.dart';
import 'package:flutterhobby/widget_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../drawer.dart';

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
        title: const Text("Swipe in Menu from the right"),
      ),
      body: SingleChildScrollView(
        controller: state._controller,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      const CircleAvatar(
                        radius: 150,
                        backgroundImage: CachedNetworkImageProvider(
                          "https://i.imgur.com/BBsl598.jpg",
                        ),
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
                        state.malteText,
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
                            image:
                                AssetImage("assets/GitHub-Mark-Light-64px.png"),
                          ),
                        ),
                        label: Text(
                          'GitHub',
                          style: Theme.of(context).textTheme.bodyText1,
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () => state
                            ._launchURL("https://github.com/MalteMagnussen"),
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
            VideoPlayerScreen(video: "https://i.imgur.com/QxVpNAV.mp4"),
            CachedNetworkImage(
              imageUrl: "https://i.imgur.com/a5778wA.jpg",
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key? key, required this.video}) : super(key: key);

  String video;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(widget.video);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _controller.setVolume(0);
        _controller.setLooping(true);
        _controller.play();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder to display a loading spinner while waiting for the
    // VideoPlayerController to finish initializing.
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: VideoPlayer(_controller),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(
            child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

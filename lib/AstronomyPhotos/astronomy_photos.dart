import 'package:flutter/material.dart';
import 'package:flutterhobby/GalleryComponents/gallery_wrapper.dart';
import 'package:flutterhobby/GalleryComponents/label.dart';
import 'package:flutterhobby/MuseumFeature/museum_image_viewer.dart';
import 'apod_fetch.dart';
import 'apod_model.dart';
import 'apod_helpers.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'youtube_parser.dart';

import '../drawer.dart';

// TODO - Refactor Museum and Astronomy Photos to use the same code.
// use https://api.flutter.dev/flutter/dart-core/DateTime-class.html for date
// use DateTime.add(Duration) to add days to date
// use DateTime.subtract(Duration) to subtract days from date
// Do that for going left and right. Don't allow user to go right, if Date is Today.
// Don't allow user to go left or right, if they're at the end or beginning of the museum images.
// https://api.flutter.dev/flutter/dart-core/Duration-class.html for Duration
// TODO - Add cool animations and effects

class NasaWidget extends StatefulWidget {
  const NasaWidget({Key? key}) : super(key: key);

  @override
  _NasaWidgetState createState() => _NasaWidgetState();
}

class _NasaWidgetState extends State<NasaWidget> {
  late Future<Apod> apod;

  @override
  void initState() {
    apod = fetchAPOD(DateTime.now());
    super.initState();
  }

  final PageController pageController = PageController(
    keepPage: true,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HobbyNavigation(),
      appBar: AppBar(
        title: const Text('NASA Images'),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: GalleryWrapper(
              pageController: pageController,
              length: 0,
              pageViewItemBuilder: buildImage,
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<Apod> buildImage(double index, int length) {
    ApodHelpers helpers = ApodHelpers();
    return FutureBuilder<Apod>(
      future: fetchAPOD(
        helpers.subtractDays(
          DateTime.now(),
          index.toInt(),
        ),
      ),
      builder: (BuildContext context, AsyncSnapshot<Apod> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Apod apod = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Label(
                image: apod.hdurl,
                title: apod.title,
                subtitle: apod.explanation,
              ),
              Expanded(
                child: buildApodContent(apod),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Copyright: " + apod.copyright,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildApodContent(Apod apod) {
    if (apod.mediaType == 'image') {
      return MuseumImageViewer(
        imageUrl: apod.hdurl,
      );
    } else {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: convertUrlToId(apod.url)!,
      );
      return YoutubePlayerIFrame(
        controller: _controller,
        aspectRatio: 16 / 9,
      );
    }
  }
}

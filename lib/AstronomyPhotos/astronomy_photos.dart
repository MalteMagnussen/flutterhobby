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
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Label(
                  image: apod.mediaType == "image" ? apod.hdurl : apod.url,
                  title: apod.title,
                  subtitle: apod.explanation,
                ),
                Flexible(
                  child: buildApodContent(apod),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Copyright: " + apod.copyright,
                  ),
                ),
              ],
            ),
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
      return Center(
        child: YoutubePlayerIFrame(
          controller: _controller,
          aspectRatio: 16 / 9,
        ),
      );
    }
  }
}

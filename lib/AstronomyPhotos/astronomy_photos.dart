import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterhobby/AstronomyPhotos/label.dart';
import 'apod_fetch.dart';
import 'apod_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HobbyNavigation(),
      appBar: AppBar(
        title: const Text('NASA Images'),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<Apod>(
                  future: apod,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          LabelWidget(
                            title: snapshot.data!.title,
                            subtitle: snapshot.data!.explanation,
                            image: snapshot.data!.hdurl,
                          ),
                          Image.network(
                            snapshot.data!.hdurl,
                            fit: BoxFit.cover,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Copyright: " + snapshot.data!.copyright,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

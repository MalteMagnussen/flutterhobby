import 'package:flutter/material.dart';
import 'package:flutterhobby/MainScreen/malte_socials.dart';
import 'package:flutterhobby/MuseumFeature/museum_main.dart';

import 'GuessMyAgeFeature/guess_my_age.dart';
import 'ImageSorting/image_sorter.dart';
import 'AstronomyPhotos/astronomy_photos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final List<String> navigationPath = [
    '/',
    //'/guessage',
    //'/imagesorting',
    '/museum',
    '/nasa',
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Malte Hviid-Magnussen",
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        navigationPath[0]: (context) => const MalteSocials(),
        navigationPath[1]: (context) => const MuseumWidget(),
        navigationPath[2]: (context) => const NasaWidget(),
        //navigationPath[1]: (context) => const GuessMyAgeWidget(),
        //navigationPath[2]: (context) => const SortImageWidget(),
      },
    );
  }
}

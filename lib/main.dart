import 'package:flutter/material.dart';
import 'package:flutterhobby/MainScreen/malte_socials.dart';

import 'GuessMyAgeFeature/guess_my_age.dart';
import 'ImageSorting/image_sorter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Malte Hviid-Magnussen",
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => MalteSocials(),
        '/guessage': (context) => const GuessMyAgeWidget(),
        '/imagesorting': (context) => const SortImageWidget(),
      },
    );
  }
}

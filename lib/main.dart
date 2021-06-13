import 'package:flutter/material.dart';
import 'GuessMyAgeFeature/agify.dart';
import 'GuessMyAgeFeature/guess_my_age.dart';

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
      home: const GuessMyAgeWidget(),
    );
  }
}

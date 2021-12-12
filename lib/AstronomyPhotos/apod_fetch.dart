import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'apod_model.dart';

// https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2017-07-08&hd=true

Future<Apod> fetchAPOD(DateTime date) async {
//const String nasaApiKey = 'DEMO_KEY';
  if (kDebugMode) {
    print('fetching apod for $date');
  }
  const String nasaApiKey =
      "XPqRfCBcQjGUDpf4wPT1Hr1jgKWATnpIbNq4csLH"; // "DEMO_KEY";
  final String url =
      'https://api.nasa.gov/planetary/apod?api_key=$nasaApiKey&date=${date.year}-${date.month}-${date.day}&hd=true';
  if (kDebugMode) {
    print('url: $url');
  }
  final response = await http.get(
    Uri.parse(
      'https://api.nasa.gov/planetary/apod?api_key=$nasaApiKey&date=${date.year}-${date.month}-${date.day}&hd=true',
    ),
  );

  if (response.statusCode == 200) {
    return Apod.fromJson(json.decode(response.body));
  } else {
    if (kDebugMode) {
      print(response.body);
    }
    throw Exception('Failed to fetch APOD');
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'artwork.dart';

Future<Artwork> fetchArtwork(int objectID) async {
  final response = await http.get(
    Uri.parse(
      'https://collectionapi.metmuseum.org/public/collection/v1/objects/$objectID',
    ),
  );

  if (response.statusCode == 200) {
    return Artwork.fromJson(
      jsonDecode(response.body),
    );
  } else {
    throw Exception("Couldn't fetch Artwork.");
  }
}

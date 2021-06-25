import 'dart:convert';

import 'package:http/http.dart' as http;

import 'artwork.dart';

/*
https://metmuseum.github.io/#search
https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&medium=Paintings&q=Picasso
https://collectionapi.metmuseum.org/public/collection/v1/objects/438821
*/

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

Future<List<int>> fetchPaintingsIds([String search = ""]) async {
  final response = await http.get(Uri.parse(
      "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&medium=Paintings&q=$search"));
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return json['objectIDs'];
  } else {
    throw Exception("Couldn't fetch Painting IDs.");
  }
}

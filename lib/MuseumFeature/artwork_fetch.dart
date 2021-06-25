import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'artwork.dart';

/*
https://metmuseum.github.io/#search
https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&medium=Paintings&q=Picasso
https://collectionapi.metmuseum.org/public/collection/v1/objects/438821
*/

Future<Artwork> fetchArtwork(int objectID) async {
  Random random = Random();
  String url = 'https://collectionapi.metmuseum.org/public/'
      'collection/v1/objects/$objectID?v=${random.nextInt(100000)}';
  final response = await http.get(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    Artwork artwork = Artwork.fromJson(
      jsonDecode(response.body),
    );
    print("FETCHED IMAGE ${artwork.primaryImage}");
    return artwork;
  } else {
    throw Exception("Couldn't fetch Artwork. $url");
  }
}

Future<List<int>> fetchPaintingsIds([String search = "\"\""]) async {
  final response = await http.get(
    Uri.parse(
      "https://collectionapi.metmuseum.org/public/"
      "collection/v1/search?medium=Paintings&departmentId=11&hasImages=true&q=$search",
    ),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    List<int> objectIds = List<int>.from(json['objectIDs']);
    return objectIds; // ObjectIDs.fromJson(json).objectIDs;
  } else {
    throw Exception("Couldn't fetch Painting IDs.");
  }
}

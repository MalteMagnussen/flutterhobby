import 'dart:convert';

import 'package:http/http.dart' as http;

import 'artwork.dart';

Future<Artwork> fetchArtwork(int objectID) async {
  final nationalizeResponse = await http.get(
    Uri.parse(
      'https://collectionapi.metmuseum.org/public/collection/v1/objects/$objectID',
    ),
  );

  return Artwork.fromJson(
    jsonDecode(nationalizeResponse.body),
  );
}

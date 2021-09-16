import 'dart:convert';
import 'dart:math';

import 'package:flutterhobby/MuseumFeature/build_search_string.dart';
import 'package:http/http.dart' as http;

import 'artwork.dart';

List<int> shuffle(List<int> items) {
  var random = Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}
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
    // ignore: avoid_print
    print("FETCHED IMAGE ${artwork.primaryImage}");
    return artwork;
  } else {
    throw Exception("Couldn't fetch Artwork. $url");
  }
}

Future<List<int>> fetchPaintingsIds([String search = "\"\""]) async {
  BuildSearchString searchStringBuilder = BuildSearchString();
  String searchString = "";
  switch (search) {
    case "Random paintings":
      searchStringBuilder = searchStringBuilder
        ..setDepartmentId(11)
        ..setMedium("Paintings")
        ..setSearch("\"\"");
      searchString = searchStringBuilder.buildSearchString();
      break;
    case "Claude Monet":
      searchStringBuilder = searchStringBuilder
        ..setDepartmentId(11)
        ..setMedium("Paintings")
        ..setSearch(search);
      searchString = searchStringBuilder.buildSearchString();
      break;
    case "Leonardo da Vinci":
      searchStringBuilder = searchStringBuilder
        ..setDepartmentId(9)
        ..setArtistOrCulture(true)
        ..setSearch(search);
      searchString = searchStringBuilder.buildSearchString();
      break;
    case "Michelangelo Buonarroti":
      searchStringBuilder = searchStringBuilder
        ..setArtistOrCulture(true)
        ..setSearch(search);
      searchString = searchStringBuilder.buildSearchString();
      break;
    case "Raphael Sanzio da Urbino":
      searchStringBuilder = searchStringBuilder
        ..setArtistOrCulture(true)
        ..setDepartmentId(9)
        ..setSearch(search);
      searchString = searchStringBuilder.buildSearchString();
      break;
    default:
      searchString = searchStringBuilder.normalSearch(search);
  }
  final response = await http.get(
    Uri.parse(searchString),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    List<int> objectIds = List<int>.from(json['objectIDs']);

    return shuffle(objectIds); // ObjectIDs.fromJson(json).objectIDs;
  } else {
    throw Exception("Couldn't fetch Painting IDs.");
  }
}

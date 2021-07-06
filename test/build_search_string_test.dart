import 'package:flutter_test/flutter_test.dart';
import 'package:flutterhobby/MuseumFeature/build_search_string.dart';

void main() {
  test('Search Test', () {
    var search = 'searchtest';
    BuildSearchString searchString = BuildSearchString()
      ..setMedium("Paintings")
      ..setDepartmentId(11)
      ..setArtistOrCulture(true)
      ..setSearch(search);
    expect(
        searchString.buildSearchString(),
        equals(""
            "https://collectionapi.metmuseum.org/public/"
            "collection/v1/search?"
            "hasImages=true&"
            "medium=Paintings&"
            "departmentId=11&"
            "artistOrCulture=true&"
            "q=$search"));
  });
}

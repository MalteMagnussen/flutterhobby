import 'dart:core';

class BuildSearchString {
  String searchString = "https://collectionapi.metmuseum.org/public/"
      "collection/v1/search?hasImages=true";
  final String medium = "&medium=";
  final String departmentId = "&departmentId=";
  final String artistOrCulture = "&artistOrCulture=";

  String buildSearchString() {
    return searchString;
  }

  /// Fx "Paintings"
  void setMedium(String _medium) {
    searchString = "$searchString$medium$_medium";
  }

  /// Fx 11 for European Paintings
  void setDepartmentId(int _departmentId) {
    searchString = "$searchString$departmentId$_departmentId";
  }

  /// Set to "true" if you're searching for an artist by name.
  void setArtistOrCulture(bool _artistOrCulture) {
    searchString = "$searchString$artistOrCulture$_artistOrCulture";
  }

  void setSearch(String search) {
    searchString = "$searchString&q=$search";
  }

  String normalSearch(String search) {
    BuildSearchString searchString = BuildSearchString()
      ..setArtistOrCulture(true)
      ..setDepartmentId(11)
      ..setMedium("Paintings")
      ..setSearch(search);
    return searchString.buildSearchString();
  }
}

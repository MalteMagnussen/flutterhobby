class Artwork {
  int objectID;
  String primaryImage;
  String artistDisplayName;
  String artistDisplayBio;
  String title;
  String objectDate;

  Artwork(
    this.title,
    this.objectID,
    this.primaryImage,
    this.artistDisplayName,
    this.artistDisplayBio,
    this.objectDate,
  );

  factory Artwork.fromJson(Map<String, dynamic> json) {
    Artwork artwork = Artwork(
      json['title'],
      json['objectID'],
      json['primaryImage'],
      json['artistDisplayName'],
      json['artistDisplayBio'],
      json['objectDate'],
    );
    return artwork;
  }
}

class ObjectIDs {
  List<int> objectIDs;

  ObjectIDs(this.objectIDs);

  factory ObjectIDs.fromJson(Map<String, dynamic> json) {
    return ObjectIDs(json['objectIDs']);
  }
}

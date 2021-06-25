class Artwork {
  int objectID;
  String primaryImage;
  String artistDisplayName;
  String artistDisplayBio;

  Artwork(
    this.objectID,
    this.primaryImage,
    this.artistDisplayName,
    this.artistDisplayBio,
  );

  factory Artwork.fromJson(Map<String, dynamic> json) {
    Artwork artwork = Artwork(
      json['objectID'],
      json['primaryImage'],
      json['artistDisplayName'],
      json['artistDisplayBio'],
    );
    return artwork;
  }
}
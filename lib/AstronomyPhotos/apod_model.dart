class Apod {
  String mediaType;
  String title;
  String url;
  String hdurl;
  String explanation;
  String copyright;
  String date;

  Apod(
    this.mediaType,
    this.title,
    this.url,
    this.hdurl,
    this.explanation,
    this.copyright,
    this.date,
  );

  factory Apod.fromJson(Map<String, dynamic> json) {
    return Apod(
      json['media_type'] as String,
      json['title'] as String,
      json['url'] as String,
      json['hdurl'] == null ? "No HD image" : json['hdurl'] as String,
      json['explanation'] as String,
      json['copyright'] == null ? "No copyright" : json['copyright'] as String,
      json['date'] as String,
    );
  }
}

class PersonsAge {
  String name;
  String country;
  int age;

  PersonsAge(this.name, this.country, this.age);

  PersonsAge.name(String name) : this(name, "DK", 0);

  PersonsAge.nameCountry(String name, String country) : this(name, country, 0);

  factory PersonsAge.fromJsonNationalize(Map<String, dynamic> json) {
    try {
      if (json['name'] == "" || json['name'] == null) {
        throw Exception("No one is named that in the database.");
      }
      return PersonsAge.nameCountry(
        json['name'],
        json['country'][0]["country_id"],
      );
    } on RangeError {
      throw Exception("Name doesn't exist in the API.");
    }
  }

  factory PersonsAge.fromJsonAgify(Map<String, dynamic> json) {
    return PersonsAge(
      json['name'],
      json['country_id'],
      json['age'],
    );
  }
}

class Country {
  final String country;

  Country({required this.country});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      country: json['name'],
    );
  }

  factory Country.fromJsonCountry(List<dynamic> json) {
    return Country(
      country: json[0]['alpha2Code'],
    );
  }
}

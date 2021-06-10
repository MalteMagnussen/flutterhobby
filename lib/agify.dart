class PersonsAge {
  String name;
  String country;
  int age;

  PersonsAge(this.name, this.country, this.age);

  PersonsAge.name(String name) : this(name, "DK", 0);

  PersonsAge.nameCountry(String name, String country) : this(name, country, 0);

  factory PersonsAge.fromJsonNationalize(Map<String, dynamic> json) {
    return PersonsAge.nameCountry(
      json['name'],
      json['country'][1]["country_id"],
    );
  }

  factory PersonsAge.fromJsonAgify(Map<String, dynamic> json) {
    return PersonsAge(
      json['name'],
      json['age'],
      json['country_id'],
    );
  }
}

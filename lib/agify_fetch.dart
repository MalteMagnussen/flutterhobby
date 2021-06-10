import 'dart:convert';
import 'package:http/http.dart' as http;
import 'agify.dart';

Future<http.Response> fetchCountry(PersonsAge person) {
  return http.get(Uri.parse('https://api.nationalize.io/?name=${person.name}'));
}

Future<PersonsAge> fetchPersonsCountry(PersonsAge person) async {
  final nationalizeResponse = await fetchCountry(person);
  if (nationalizeResponse.statusCode == 200) {
    // If the server sent a fine response
    return PersonsAge.fromJsonNationalize(jsonDecode(nationalizeResponse.body));
  } else {
    throw Exception("Failed to fetch country.");
  }
}

Future<http.Response> fetchAge(PersonsAge person) {
  return http.get(
    Uri.parse(
        'https://api.agify.io/?name=${person.name}&country_id=${person.country}'),
  );
}

Future<PersonsAge> fetchPersonsAge(PersonsAge person) async {
  final agifyResponse = await fetchAge(person);
  if (agifyResponse.statusCode == 200) {
    // If the server sent a fine response
    return PersonsAge.fromJsonAgify(jsonDecode(agifyResponse.body));
  } else {
    throw Exception("Failed to fetch age.");
  }
}

Future<PersonsAge> fetchPerson(String name) async {
  PersonsAge person = PersonsAge.name(name);
  person = await fetchPersonsCountry(person);
  return await fetchPersonsAge(person);
}

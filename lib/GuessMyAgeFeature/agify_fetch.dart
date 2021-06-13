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

// https://restcountries.eu/rest/v2/alpha/dk
Future<http.Response> fetchCountryName(String country) {
  return http.get(
    Uri.parse('https://restcountries.eu/rest/v2/alpha/$country'),
  );
}

// https://restcountries.eu/rest/v2/name/Danmark
Future<http.Response> fetchCountryCode(String country) {
  return http.get(
    Uri.parse('https://restcountries.eu/rest/v2/name/$country'),
  );
}

Future<Country> fetchPersonsCountryCode(String country) async {
  final agifyResponse = await fetchCountryCode(country);
  if (agifyResponse.statusCode == 200) {
    // If the server sent a fine response
    return Country.fromJsonCountry(jsonDecode(agifyResponse.body));
  } else {
    throw Exception("Failed to fetch countrycode.");
  }
}

Future<PersonsAge> fetchPerson(String name, String countryString) async {
  Country countryCode = await fetchPersonsCountryCode(countryString);
  PersonsAge person = PersonsAge.nameCountry(name, countryCode.country);
  return await fetchPersonsAge(person);
}

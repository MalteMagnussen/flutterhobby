import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apod_model.dart';

class ApodHelpers {
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

  DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  DateTime addOneDay(DateTime date) {
    return date.add(const Duration(days: 1));
  }

  DateTime subtractOneDay(DateTime date) {
    return date.subtract(const Duration(days: 1));
  }
}

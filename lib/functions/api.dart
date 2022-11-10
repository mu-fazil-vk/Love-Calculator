import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const baseUrl = 'https://love-calculator.p.rapidapi.com';
  static const apiKey = 'API_KEY';

  static Future<Map<String, dynamic>> getData(
      String name1, String name2) async {
    Uri uri = Uri.parse(
        "https://love-calculator.p.rapidapi.com/getPercentage?sname=$name1&fname=$name2");
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Host": "love-calculator.p.rapidapi.com",
      "X-RapidAPI-Key": apiKey
    });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

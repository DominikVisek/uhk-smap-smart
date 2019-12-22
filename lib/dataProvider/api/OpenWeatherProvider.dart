import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:uhk_smap_smart_weather_reminder/config/env.dart';
import 'package:uhk_smap_smart_weather_reminder/model/api/OpenWeatherItem.dart';

class OpenWeatherProvider {

  static const BRANDS_URL = "/data/2.5/weather";

  Future<OpenWeatherItem> getByCoordinates(String lat, String lon) {
    return getOneMethod(
        BRANDS_URL, {"appid": OPEN_WEATHER_API_KEY, "lat": lat, "lon": lon});
  }

  Future<List<OpenWeatherItem>> getMethod(String url, queryParameters) async {
    Uri uri = new Uri.https(OPEN_WEATHER_API_URL, url, queryParameters);
    String urlWithQuery = uri.toString();

    final response = await http.get(urlWithQuery);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<OpenWeatherItem> list = new List();

      for (Map item in data) {
        list.add(OpenWeatherItem.fromJson(item));
      }

      return list;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<OpenWeatherItem> getOneMethod(String url, queryParameters) async {
    Uri uri = new Uri.https(OPEN_WEATHER_API_URL, url, queryParameters);
    String urlWithQuery = uri.toString();

    final response = await http.get(urlWithQuery);

    if (response.statusCode == 200) {
      return OpenWeatherItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
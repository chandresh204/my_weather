import 'dart:convert';

import '../api/api_weather.dart';
import '../api/api_weather_current.dart';
import '../api/api_weather_daily.dart';

import 'api_location.dart';
import 'package:http/http.dart' as http;

class LocationRequestFailure implements Exception { }

class ApiClient {
  final http.Client _httpClient = http.Client();
  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  Future<ApiLocation> locationSearch(String city) async {
    print('searching location');
    final locationRequest = Uri.https(
      _baseUrlGeocoding, '/v1/search', { 'name' : city, 'count' : '1' }
    );
    print('location request : $locationRequest');
    final locationResponse = await _httpClient.get(locationRequest);
    print('location response ${locationResponse.body}');
    print('converting to location object');
    final responseMap = jsonDecode(locationResponse.body) as Map;
    if(responseMap['results'] == null) {
      throw LocationRequestFailure();
    }
    final responseJson = responseMap['results'] as List;
    return ApiLocation.fromJson(responseJson.first);
  }

  Future<ApiWeather> loadWeather({required double latitude, required double longitude}) async {
    print('loading weather');
    final weatherRequest2 = Uri.https(
      _baseUrlWeather, 'v1/forecast',
      {
        'latitude' : '$latitude',
        'longitude' : '$longitude',
        'current_weather' : 'true',
        'daily' : { 'weathercode', 'temperature_2m_max', 'temperature_2m_min',
          'sunrise', 'sunset', 'precipitation_sum' },
        'timezone' : 'GMT'
      }
    );
    print('weather request : $weatherRequest2');
    final weatherResponse = await _httpClient.get(weatherRequest2);
    print('weather response : ${weatherResponse.body}');
    final weatherJson = jsonDecode(weatherResponse.body) as Map;
    final currentJson = weatherJson['current_weather'];
    final dailyJson = weatherJson['daily'];
    return ApiWeather(ApiWeatherCurrent.fromJson(currentJson),
        ApiWeatherDaily.fromJson(dailyJson), DateTime.now());
  }
}
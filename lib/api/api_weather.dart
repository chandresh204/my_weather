import 'api_weather_current.dart';
import 'api_weather_daily.dart';

class ApiWeather {
  final ApiWeatherCurrent current;
  final ApiWeatherDaily daily;
  final DateTime lastUpdated;

  ApiWeather(this.current, this.daily, this.lastUpdated);
}
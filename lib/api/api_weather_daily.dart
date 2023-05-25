
import 'package:json_annotation/json_annotation.dart';

part 'api_weather_daily.g.dart';

@JsonSerializable()
class ApiWeatherDaily {
  final List<String> time;
  final List<double> temperature_2m_max;
  final List<double> temperature_2m_min;
  final List<String> sunrise;
  final List<String> sunset;
  final List<double> precipitation_sum;
  final List<int> weathercode;

  ApiWeatherDaily(this.time, this.temperature_2m_max, this.temperature_2m_min, this.sunrise, this.sunset, this.precipitation_sum, this.weathercode);

  factory ApiWeatherDaily.fromJson(Map<String, dynamic> json) =>
      _$ApiWeatherDailyFromJson(json);
}
import 'package:json_annotation/json_annotation.dart';

part 'api_weather_current.g.dart';

@JsonSerializable()
class ApiWeatherCurrent {
  final double temperature;
  final double windspeed;
  final double winddirection;
  final int weathercode;
  ApiWeatherCurrent(this.temperature, this.windspeed, this.winddirection, this.weathercode);

  factory ApiWeatherCurrent.fromJson(Map<String,dynamic> json) =>
      _$ApiWeatherCurrentFromJson(json);
}
import 'package:json_annotation/json_annotation.dart';

part 'full_weather.g.dart';

@JsonSerializable()
class FullWeather {
  final String? place;
  final double latitude;
  final double longitude;
  final double temperature;
  final int weathercode;
  final double windspeed;
  final double winddirection;
  final String timezone;
  final List<double> dailyMaxTemperature;
  final List<double> dailyMinTemperature;
  final List<int> dailyWeatherCodes;
  final String sunrise;
  final String sunset;
  final DateTime lastUpdated;
  FullWeather(this.place, this.temperature, this.weathercode, this.windspeed, this.winddirection,
      this.timezone, this.dailyMaxTemperature, this.dailyMinTemperature,
      this.dailyWeatherCodes,
      this.sunrise, this.sunset, this.lastUpdated, this.latitude, this.longitude);

  factory FullWeather.fromJson(Map<String, dynamic> json) =>
      _$FullWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$FullWeatherToJson(this);
}
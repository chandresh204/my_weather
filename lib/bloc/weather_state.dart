
import '../view/view_data/full_weather.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_state.g.dart';

enum WeatherStatus { initial, loading, success, failure }

@JsonSerializable()
class WeatherState {

  final FullWeather? fullWeather;
  final WeatherStatus weatherStatus;

  WeatherState({required this.fullWeather, required this.weatherStatus});

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  factory WeatherState.fromJson(Map<String, dynamic> json) => 
      _$WeatherStateFromJson(json);
}
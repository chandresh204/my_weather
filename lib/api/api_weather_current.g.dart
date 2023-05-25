// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_weather_current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiWeatherCurrent _$ApiWeatherCurrentFromJson(Map<String, dynamic> json) =>
    ApiWeatherCurrent(
      (json['temperature'] as num).toDouble(),
      (json['windspeed'] as num).toDouble(),
      (json['winddirection'] as num).toDouble(),
      json['weathercode'] as int,
    );

Map<String, dynamic> _$ApiWeatherCurrentToJson(ApiWeatherCurrent instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'windspeed': instance.windspeed,
      'winddirection': instance.winddirection,
      'weathercode': instance.weathercode,
    };

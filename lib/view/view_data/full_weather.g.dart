// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullWeather _$FullWeatherFromJson(Map<String, dynamic> json) => FullWeather(
      json['place'] as String?,
      (json['temperature'] as num).toDouble(),
      json['weathercode'] as int,
      (json['windspeed'] as num).toDouble(),
      (json['winddirection'] as num).toDouble(),
      json['timezone'] as String,
      (json['dailyMaxTemperature'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['dailyMinTemperature'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['dailyWeatherCodes'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      json['sunrise'] as String,
      json['sunset'] as String,
      DateTime.parse(json['lastUpdated'] as String),
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$FullWeatherToJson(FullWeather instance) =>
    <String, dynamic>{
      'place': instance.place,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'temperature': instance.temperature,
      'weathercode': instance.weathercode,
      'windspeed': instance.windspeed,
      'winddirection': instance.winddirection,
      'timezone': instance.timezone,
      'dailyMaxTemperature': instance.dailyMaxTemperature,
      'dailyMinTemperature': instance.dailyMinTemperature,
      'dailyWeatherCodes': instance.dailyWeatherCodes,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

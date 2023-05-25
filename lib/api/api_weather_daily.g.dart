// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_weather_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiWeatherDaily _$ApiWeatherDailyFromJson(Map<String, dynamic> json) =>
    ApiWeatherDaily(
      (json['time'] as List<dynamic>).map((e) => e as String).toList(),
      (json['temperature_2m_max'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['temperature_2m_min'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['sunrise'] as List<dynamic>).map((e) => e as String).toList(),
      (json['sunset'] as List<dynamic>).map((e) => e as String).toList(),
      (json['precipitation_sum'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['weathercode'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$ApiWeatherDailyToJson(ApiWeatherDaily instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m_max': instance.temperature_2m_max,
      'temperature_2m_min': instance.temperature_2m_min,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'precipitation_sum': instance.precipitation_sum,
      'weathercode': instance.weathercode,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherState _$WeatherStateFromJson(Map<String, dynamic> json) => WeatherState(
      fullWeather: json['fullWeather'] == null
          ? null
          : FullWeather.fromJson(json['fullWeather'] as Map<String, dynamic>),
      weatherStatus: $enumDecode(_$WeatherStatusEnumMap, json['weatherStatus']),
    );

Map<String, dynamic> _$WeatherStateToJson(WeatherState instance) =>
    <String, dynamic>{
      'fullWeather': instance.fullWeather,
      'weatherStatus': _$WeatherStatusEnumMap[instance.weatherStatus]!,
    };

const _$WeatherStatusEnumMap = {
  WeatherStatus.initial: 'initial',
  WeatherStatus.loading: 'loading',
  WeatherStatus.success: 'success',
  WeatherStatus.failure: 'failure',
};

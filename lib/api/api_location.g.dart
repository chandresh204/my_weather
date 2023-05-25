// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiLocation _$ApiLocationFromJson(Map<String, dynamic> json) => ApiLocation(
      json['name'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      json['timezone'] as String,
    );

Map<String, dynamic> _$ApiLocationToJson(ApiLocation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
    };

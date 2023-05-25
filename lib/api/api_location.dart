import 'package:json_annotation/json_annotation.dart';

part 'api_location.g.dart';

@JsonSerializable()
class ApiLocation {
  final String name;
  final double latitude;
  final double longitude;
  final String timezone;
  ApiLocation(this.name, this.latitude, this.longitude, this.timezone);

  factory ApiLocation.fromJson(Map<String,dynamic> json) =>
      _$ApiLocationFromJson(json);
}
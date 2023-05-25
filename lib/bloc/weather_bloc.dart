import 'package:flutter/material.dart';

import '../bloc/weather_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../repository/repository.dart';

class WeatherBloc extends HydratedCubit<WeatherState> {

  final Repository _repository;
  WeatherBloc({required Repository repository}) :
        _repository = repository,
        super(WeatherState(fullWeather: null, weatherStatus: WeatherStatus.initial));

  backToInitial() {
    emit(WeatherState(fullWeather: null, weatherStatus: WeatherStatus.initial));
  }

  Future<void> startLoading(String? city,double latitude,double longitude) async {
    try {
      emit(WeatherState(fullWeather: null, weatherStatus: WeatherStatus.loading));
      final fullWeather = await _repository.startLoading(cityName: city, latitude: latitude, longitude: longitude);
      emit(WeatherState(fullWeather: fullWeather, weatherStatus: WeatherStatus.success));
    } on Exception {
      emit(WeatherState(fullWeather: null, weatherStatus: WeatherStatus.failure));
    }
  }

  Future<void> getLocationAndShowWeather(BuildContext context) async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
    //  print('GPS is turned off');
      // ask user to turn on UPS
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location is off, Please turn it on and try again'))
      );
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission Denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permission denied forever');
    }
    emit(WeatherState(fullWeather: null, weatherStatus: WeatherStatus.loading));
    final position = await Geolocator.getCurrentPosition();
    try {
      final fullWeather = await _repository.startLoading(cityName: null,
          latitude: position.latitude, longitude: position.longitude);
      emit(WeatherState(fullWeather: fullWeather, weatherStatus: WeatherStatus.success));
    } on Exception {
      emit(WeatherState(fullWeather: null, weatherStatus: WeatherStatus.failure));
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    final weatherState = WeatherState.fromJson(json);
    if(weatherState.weatherStatus == WeatherStatus.loading
        || weatherState.weatherStatus == WeatherStatus.failure) {
      return WeatherState(fullWeather: null, weatherStatus: WeatherStatus.initial);
    }
    return weatherState;
  }

   @override
   Map<String, dynamic>? toJson(WeatherState state) => state.toJson();
}
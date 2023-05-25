import '../api/api_client.dart';
import '../api/api_location.dart';
import '../view/view_data/full_weather.dart';

class Repository {
  final ApiClient apiClient;

  Repository({required this.apiClient });

  Future<FullWeather> startLoading({
    required String? cityName,
    required double latitude,
    required double longitude
  }) async {
    ApiLocation? apiLocation;
    if(cityName != null && cityName != 'Here') {
      apiLocation = await apiClient.locationSearch(cityName);
      latitude = apiLocation.latitude;
      longitude = apiLocation.longitude;
    }
    final apiWeather = await apiClient.loadWeather(latitude: latitude,
        longitude: longitude);
    return FullWeather(
        cityName ?? 'Here',
        apiWeather.current.temperature,
        apiWeather.current.weathercode,
        apiWeather.current.windspeed,
        apiWeather.current.winddirection,
        apiLocation?.timezone ?? 'Local Time',
        apiWeather.daily.temperature_2m_max,
        apiWeather.daily.temperature_2m_min,
        apiWeather.daily.weathercode,
        apiWeather.daily.sunrise.first,
        apiWeather.daily.sunset.first,
        apiWeather.lastUpdated,
        latitude,
        longitude
    );
  }
}
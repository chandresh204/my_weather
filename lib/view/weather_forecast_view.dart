import 'package:flutter/material.dart';

class WeatherForecastView extends StatelessWidget {
  final List<double> maxForecasts;
  final List<double> minForecasts;
  final List<int> weatherCodes;
  final List<String> dayNames;
  const WeatherForecastView({Key? key,
    required this.maxForecasts,
    required this.minForecasts, required this.weatherCodes,
    required this.dayNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color.fromARGB(150, 0, 0, 0),
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: Center(
        child: ListView.builder(
          itemCount: maxForecasts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width -32) / maxForecasts.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${maxForecasts[i].floor().toString()}°', style: const TextStyle(color: Colors.white)),
                    getWeatherIcon(weatherCodes[i], Colors.white),
                    Text('${minForecasts[i].floor().toString()}°', style: const TextStyle(color: Colors.white)),
                    Text(dayNames[i], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              );
            }
        ),
      )
    );
  }

  Icon getWeatherIcon(int weathercode, Color color) {
    switch(weathercode) {
      case 0:
      case 1: return Icon(Icons.sunny, color: color);
      case 2:
      case 3: return Icon(Icons.cloud, color: color);
      case 45:
      case 48: return Icon(Icons.waves, color: color);
      case 51:
      case 53:
      case 55: return Icon(Icons.waves, color: color);
      case 56:
      case 57: return Icon(Icons.severe_cold, color: color);
      case 61:
      case 63: return Icon(Icons.cloudy_snowing, color: color);
      case 65 : return Icon(Icons.thunderstorm, color: color);
      case 66:
      case 67: return Icon(Icons.severe_cold, color: color);
      case 71:
      case 73:
      case 75: return Icon(Icons.snowing, color: color);
    }
    return Icon(Icons.sunny, color: color);
  }
}

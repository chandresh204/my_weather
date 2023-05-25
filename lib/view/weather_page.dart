import 'dart:io';

import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../repository/repository.dart';
import '../view/view_data/full_weather.dart';
import '../view/weather_city_enter_dialog.dart';
import '../view/weather_forecast_view.dart';
import '../view/weather_wind_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WeatherBloc(repository: Repository(apiClient: ApiClient())),
      child: WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  WeatherView({Key? key}) : super(key: key);

  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (ctx, state) {
            switch (state.weatherStatus) {
              case WeatherStatus.initial:
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    'click add button to add City',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(onPressed: () {
                    context.read<WeatherBloc>().getLocationAndShowWeather(context);
                  },
                      child: Text('Or Locate'))
                  //        WeatherForecastView()
                ]);
              case WeatherStatus.loading:
                return const CircularProgressIndicator();
              case WeatherStatus.success:
                return FullWeatherView(fullWeather: state.fullWeather);
              case WeatherStatus.failure:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('An Error Occured'),
                    TextButton(onPressed: () {
                      context.read<WeatherBloc>().backToInitial();
                    }, child: const Text('Go to Home'))
                  ],
                );
            }
          },
        ),
      ),
      floatingActionButton: BlocBuilder<WeatherBloc, WeatherState>(
       builder: (context, state) {
         return FloatingActionButton(onPressed: () {
           showDialog(context: context, builder: (ctx) {
             return cityDialog(context, _cityController);
           });
         }, child: const Icon(Icons.add));
       },
      )
    );
  }
}

class FullWeatherView extends StatefulWidget {
  final FullWeather? fullWeather;
  const FullWeatherView({Key? key, required this.fullWeather})
      : super(key: key);

  @override
  State<FullWeatherView> createState() => _FullWeatherViewState();
}

class _FullWeatherViewState extends State<FullWeatherView> with SingleTickerProviderStateMixin {

  late AnimationController aController;
  late Animation<double> animation;
  String sunriseSunsetTime = "";

  @override
  void initState() {
    super.initState();
    aController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = CurvedAnimation(parent: aController, curve: Curves.decelerate);
    aController.forward();
    _checkInternetAndRefresh();
  }

  void _checkInternetAndRefresh() async {
    try {
      final result = await InternetAddress.lookup('api.open-meteo.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var currentTime = DateTime.now().millisecondsSinceEpoch;
        var lastUpdated = widget.fullWeather?.lastUpdated.millisecondsSinceEpoch;
        if((currentTime - (lastUpdated ?? 0)) > 600000) {
          context.read<WeatherBloc>().startLoading(
              widget.fullWeather?.place,
              widget.fullWeather?.latitude ?? 0.0,
              widget.fullWeather?.longitude ?? 0.0);
        }
      }
    } on SocketException catch(_) {
      print('network error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var fullWeather = widget.fullWeather;
    if (fullWeather == null) {
      return const Icon(Icons.error_outline, color: Colors.red, size: 100);
    }
    return Stack(alignment: Alignment.topLeft, children: [
      _backgroundAsPerWeatherCode(fullWeather.weathercode ?? 0, _isNight(fullWeather),
          fullWeather.temperature ?? 20.0,
          context),
      Padding(
        padding: const EdgeInsets.only(top: 40, left: 20),
        child: Row(children: [
          IconButton(
              onPressed: () {
                context.read<WeatherBloc>().startLoading(fullWeather.place,
                    fullWeather.latitude ?? 0.0, fullWeather.longitude ?? 0.0);
              },
              icon: const Icon(Icons.replay, shadows: [
                BoxShadow(blurRadius: 1.0, color: Colors.white)
              ],)
          ),
          IconButton(
              onPressed: () {
                context.read<WeatherBloc>().getLocationAndShowWeather(context);
              },
              icon: const Icon(Icons.location_on_outlined, shadows: [
                BoxShadow(blurRadius: 1.0, color: Colors.white)
              ],))
        ])
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(fullWeather.place ?? 'unknown',
                style: _shadowedTextStyle(36)),
            Text('${fullWeather.temperature.toString() ?? 'NA'}°C',
                style: _shadowedTextStyle(42)),
            ScaleTransition(
              scale: animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(sunriseSunsetTime, style: const TextStyle(color: Colors.white),),
                  WeatherWindView2(
                    windDirection: fullWeather.winddirection.toInt() ?? 0,
                    windSpeed: fullWeather.windspeed ?? 0.0),
                ]
              ),
            ),

            Expanded(child: Container()),
            ScaleTransition(
              scale: animation,
              child: WeatherForecastView(
                maxForecasts: fullWeather.dailyMaxTemperature ?? <double>[],
                minForecasts: fullWeather.dailyMinTemperature ?? [],
                weatherCodes: fullWeather.dailyWeatherCodes ?? [],
                dayNames: [
                  'TD',
                  'TM',
                  _getDayPerInt(2),
                  _getDayPerInt(3),
                  _getDayPerInt(4),
                  _getDayPerInt(5),
                  _getDayPerInt(6)
                ],
              ),
            ) ,
            Text(
              'Updated On : ${_formatLastUpdateTime(fullWeather.lastUpdated ?? DateTime(2000))}',
              style: _shadowedTextStyle(15),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    ]);
  }

  bool _isNight(FullWeather? fullWeather) {
    var utcMil =  DateTime.now().millisecondsSinceEpoch - DateTime.now().timeZoneOffset.inMilliseconds;
    var utcTime = DateTime.fromMillisecondsSinceEpoch(utcMil);
    var utcHour = utcTime.hour;
    var utcMin = utcTime.minute;
    var sunriseHour = int.parse((fullWeather?.sunrise.split('T')[1] ?? '00:00').split(':')[0]);
    var sunriseMinute = int.parse((fullWeather?.sunrise.split('T')[1] ?? '00:00').split(':')[1]);
    var sunsetHour = int.parse((fullWeather?.sunset.split('T')[1] ?? '00:00').split(':')[0]);
    var sunsetMinute = int.parse((fullWeather?.sunset.split('T')[1] ?? '00:00').split(':')[1]);
    print('DayNight: sunrise : $sunriseHour:$sunriseMinute, '
        'sunset: $sunsetHour:$sunsetMinute, '
        'current: $utcHour:$utcMin');
    bool isNight = false;
    if(sunsetHour < sunriseHour) {
      isNight = true;
      if(utcHour < sunsetHour || utcHour > sunriseHour) isNight = false;
      if(utcHour == sunsetHour && (utcMin < sunsetMinute)) isNight = false;
      if(utcHour == sunriseHour && (utcMin > sunriseMinute)) isNight = false;
    } else {
      if(utcHour > sunsetHour || utcHour < sunriseHour) isNight = true;
      if(utcHour == sunriseHour && (utcMin < sunriseMinute)) isNight = true;
      if(utcHour == sunsetHour && (utcMin > sunsetMinute)) isNight = true;
    }
    print('IsNight : $isNight');
    _getSunriseSunsetTimesForLocal(fullWeather, sunriseHour, sunriseMinute, sunsetHour, sunsetMinute);
    return isNight;
  }

  void _getSunriseSunsetTimesForLocal(FullWeather? fullWeather, int sunriseHour,
      int sunriseMinute, int sunsetHour, int sunsetMinute) {
    var localOffsetHour = DateTime.now().timeZoneOffset.inHours;
    var localMinuteOffset = (DateTime.now().timeZoneOffset.inMinutes) % 60;
    var sunrise = DateTime(0, 0, 0, sunriseHour, sunriseMinute, 0)
        .add(Duration(hours: localOffsetHour)).add(Duration(minutes: localMinuteOffset));
    var sunset = DateTime(0,0,0, sunsetHour, sunsetMinute, 0)
        .add(Duration(hours: localOffsetHour)).add(Duration(minutes: localMinuteOffset));
    print('hours :$localOffsetHour : $localMinuteOffset, sunrise: $sunrise, sunset: $sunset');
    var riseMinute = sunrise.minute.toString().padLeft(2, '0');
    var setMinute = sunset.minute.toString().padLeft(2, '0');
    sunriseSunsetTime = "Sunrise  ${sunrise.hour}:$riseMinute\nSunset  ${sunset.hour}:$setMinute";
  }

  Widget _backgroundAsPerWeatherCode(int weatherCode,bool isNight,
      double temperature,
      BuildContext context) {
    Image imageChild = Image.asset('assets/images/achievement_illustration.png');
    // weather codes:
    // 0 - clear
    // 1,2,3 - almost clear, partly cloudy, overcast
    switch (weatherCode) {
      case 0:
      case 1:
        if(isNight) {
          imageChild = Image.asset('assets/images/clear_night.png');
        } else {
          imageChild = Image.asset('assets/images/sunny2.png');
          if(temperature > 35) {
            imageChild = Image.asset('assets/images/weather_sunny_hot.png');
          }
          if(temperature > 40) {
            imageChild = Image.asset('assets/images/weather_sunny_ex_hot.png');
          }
        }
        break;
      case 2:
      case 3:
        if(isNight) {
          imageChild = Image.asset('assets/images/cloudy_night.png');
        } else {
          imageChild = Image.asset('assets/images/cloudy.png');
        }
        break;
    // 45, 48 fog and depositing rime fog
      case 45:
      case 48:
        imageChild = Image.asset('assets/images/haze2.jpg');
        break;
    // 51,53,55 Drizzle: light , moderate ,dense
      case 51:
      case 53:
      case 55:
        imageChild = Image.asset('assets/images/haze.jpg');
        break;
    // 56,57 Freezing Drizzle: light and dense
      case 56:
      case 57:
        imageChild = Image.asset('assets/images/snow.jpg');
        break;
    // 61, 63, 65 Rain: slight, moderate and heavy
      case 61:
      case 63:
        imageChild = Image.asset('assets/images/light_rain.png');
        break;
      case 65:
        imageChild = Image.asset('assets/images/heavy_rain.png');
        break;
    // 66, 67 freezing rain light and heavy
      case 66:
      case 67:
        imageChild = Image.asset('assets/images/snow.jpg');
        break;
    // 71,73,75 Snowfall, slight , moderate and heavy
      case 71:
      case 73:
      case 75:
        imageChild = Image.asset('assets/images/snow.jpg');
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          print('on background tap');
          if(aController.isCompleted) {
            aController.reverse();
          } else {
            aController.forward();
          }
        },
        child: FittedBox(
          fit: BoxFit.fill,
          child: imageChild,
        ),
      ),
    );
  }
}

String _formatLastUpdateTime(DateTime lastUpdate) {
  final nowTime = DateTime.now();
  if (nowTime.day != lastUpdate.day) {
    return 'Long Ago';
  }
  return '${lastUpdate.hour}:${lastUpdate.minute}';
}

String _getDayPerInt(int dayInt) {
  final today = DateTime.now();
  final newDay = today.add(Duration(days: dayInt));
  return '${newDay.day}';
}


TextStyle _shadowedTextStyle(double fontSize) {
  return TextStyle(
    shadows: const [Shadow(color: Colors.black, blurRadius: 2.0)],
    color: Colors.white,
    fontSize: fontSize,
  );
}

Widget _debugView(FullWeather? fullWeather) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('daily Max : ${fullWeather?.dailyMaxTemperature}'),
      Text('daily Min : ${fullWeather?.dailyMinTemperature}'),
      Text('weatherCodes : ${fullWeather?.weathercode}'),
      Text('sunrise: ${fullWeather?.sunrise}'),
      Text('sunset : ${fullWeather?.sunset}'),
    ],
  );
}

String _getCityNameFromDialog(BuildContext ctx) {
  TextEditingController controller = TextEditingController();
  showDialog(context: ctx,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
              ),
              TextButton(onPressed: () {
                ctx.read<WeatherBloc>().startLoading(
                 controller.text, 0, 0);
                Navigator.pop(ctx);
              }, child: const Text('Submit'))
            ],
          ),
        );
      });
  return 'hello';
}

class CitySelectDialog extends StatelessWidget {
  CitySelectDialog._();

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => CitySelectDialog._());
  }

  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
                hintText: 'Tokyo', labelText: 'City Name'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(_cityController.text);
              },
              child: const Text('Submit'))
        ],
      ),
    ));
  }
}

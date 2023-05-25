import 'package:flutter/material.dart';

class WeatherWindView2 extends StatefulWidget {
  final int windDirection;
  final double windSpeed;
  const WeatherWindView2({Key? key, required this.windDirection, required this.windSpeed}) : super(key: key);

  @override
  State<WeatherWindView2> createState() => _WeatherWindView2State();
}

class _WeatherWindView2State extends State<WeatherWindView2> with SingleTickerProviderStateMixin {

  late AnimationController _aController;
  late Animation<double> _animation;
  @override
  void initState() {
    final angleRot = (widget.windDirection / 360) + 0.5 ;
    _aController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animation = Tween<double>(begin: -1, end: angleRot).animate(CurvedAnimation(parent: _aController, curve: Curves.elasticOut));
    _aController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _aController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(140, 0, 0, 0),
          borderRadius: BorderRadius.circular(16.0)
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Wind', style: TextStyle(color: Colors.white)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                    turns: _animation,
                    child: Icon(Icons.arrow_upward_sharp, color: Colors.white,),
                ),
                Text(_windDirection(widget.windDirection), style: TextStyle(fontSize: 22, color: Colors.white),)
              ],
            ),
            Text('${widget.windSpeed} Km/hr', style: TextStyle(fontSize: 22, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}

String _windDirection(int angle) {
  print('Wind direcetion: $angle');
  if ( (angle >= 338 && angle < 361) || (angle >=0 && angle < 23)) {
    return 'N';
  }
  if (angle >= 23 && angle < 68) {
    return 'NE';
  }
  if (angle >= 68 && angle < 113) {
    return 'E';
  }
  if (angle >= 113 && angle < 158) {
    return 'SE';
  }
  if (angle >= 158 && angle < 203) {
    return 'S';
  }
  if (angle >= 203 && angle < 248) {
    return 'SW';
  }
  if (angle >=248 && angle < 293) {
    return 'W';
  }
  return 'NW';
}


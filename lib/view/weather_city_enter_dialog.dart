import 'package:flutter/material.dart';
import '../bloc/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Dialog cityDialog(BuildContext ctx, TextEditingController controller) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0)
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'City Name',
              hintText: 'Tokyo'
            )
            ),
          const SizedBox(height: 10),
          TextButton(onPressed: () {
            ctx.read<WeatherBloc>().startLoading( controller.text, 0, 0);
            Navigator.pop(ctx);
          }, child: const Text('Submit'))
        ],
      ),
    ),
  );
}
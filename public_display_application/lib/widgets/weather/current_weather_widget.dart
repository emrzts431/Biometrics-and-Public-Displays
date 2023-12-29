import 'package:flutter/material.dart';
import 'package:public_display_application/models/weather_item.dart';

class CurrentWeatherWidget extends StatelessWidget {
  WeatherItem weatherItem;

  CurrentWeatherWidget({super.key, required this.weatherItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.network(
                weatherItem.icon,
                scale: 0.4,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                weatherItem.text,
              )
            ],
          ),
          const SizedBox(
            width: 45,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${weatherItem.temperature}°C"),
              const SizedBox(
                height: 5,
              ),
              Text(weatherItem.locationName),
              Text(weatherItem.regionName),
              const SizedBox(
                height: 15,
              ),
              Text(
                setUpTimeString(
                  weatherItem.time,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String setUpTimeString(DateTime time) {
    return "${time.hour < 10 ? "0${time.hour}" : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute}";
  }
}

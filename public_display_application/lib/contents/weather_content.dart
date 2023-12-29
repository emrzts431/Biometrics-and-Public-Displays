import 'package:flutter/material.dart';
import 'package:public_display_application/models/weather_item.dart';
import 'package:public_display_application/widgets/weather/current_weather_widget.dart';

class WeatherContent extends StatefulWidget {
  List<WeatherItem> data;

  WeatherContent({required this.data});

  @override
  State<StatefulWidget> createState() {
    return WeatherContentState();
  }
}

class WeatherContentState extends State<WeatherContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CurrentWeatherWidget(weatherItem: widget.data.first),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 8),
              //scrollDirection: Axis.horizontal,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                WeatherItem curItem = widget.data[index];
                if (index != 0) {
                  return ListTile(
                    leading: Image.network(curItem.icon),
                    title: Text("${curItem.temperature}°C"),
                    subtitle: Text(curItem.text),
                    trailing: Text(
                      setUpTimeString(
                        curItem.time,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String setUpTimeString(DateTime time) {
    return "${time.hour < 10 ? "0${time.hour}" : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute}";
  }
}

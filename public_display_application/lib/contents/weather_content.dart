import 'package:flutter/material.dart';
import 'package:public_display_application/generated/l10n.dart';
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
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CurrentWeatherWidget(weatherItem: widget.data.first),
          const SizedBox(
            height: 20,
          ),
          Text(
            "${S.of(context).weatherForecast} ${widget.data.first.time.day}.${widget.data.first.time.month}.${widget.data.first.time.year}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            width: 400,
            height: 170,
            child: Scrollbar(
              thumbVisibility: true,
              controller: _controller,
              child: SizedBox(
                width: 400,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  separatorBuilder: (BuildContext context, int index) {
                    if (index != 0) {
                      return const Divider(color: Colors.black, thickness: 0.7);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) {
                    WeatherItem curItem = widget.data[index];
                    if (index != 0) {
                      if (curItem.time.compareTo(DateTime.now()) >= 0) {
                        return SizedBox(
                          width: 170,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(curItem.icon),
                                Text("${curItem.temperature}°C"),
                                Text(curItem.text),
                                Text(
                                  setUpTimeString(
                                    curItem.time,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
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

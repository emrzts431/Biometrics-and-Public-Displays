import 'package:json_annotation/json_annotation.dart';
part 'weather_item.g.dart';

@JsonSerializable()
class WeatherItem {
  double temperature;
  String text;
  String icon;
  DateTime time;
  String locationName;
  String regionName;

  WeatherItem({
    required this.temperature,
    required this.text,
    required this.icon,
    required this.time,
    required this.locationName,
    required this.regionName,
  });

  factory WeatherItem.fromJson(Map<String, dynamic> json) =>
      _$WeatherItemFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherItemToJson(this);
}

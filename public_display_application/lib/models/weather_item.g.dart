// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherItem _$WeatherItemFromJson(Map<String, dynamic> json) => WeatherItem(
      temperature: (json['temperature'] as num).toDouble(),
      text: json['text'] as String,
      icon: json['icon'] as String,
      time: DateTime.parse(json['time'] as String),
      locationName: json['locationName'] as String,
      regionName: json['regionName'] as String,
    );

Map<String, dynamic> _$WeatherItemToJson(WeatherItem instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'text': instance.text,
      'icon': instance.icon,
      'time': instance.time.toIso8601String(),
      'locationName': instance.locationName,
      'regionName': instance.regionName,
    };

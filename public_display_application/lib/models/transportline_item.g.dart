// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transportline_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransportLineItem _$TransportLineItemFromJson(Map<String, dynamic> json) =>
    TransportLineItem(
      platformName: json['platformName'] as String,
      realtimeTripStatus: _statusFromJson(json['realtimeTripStatus'] as String),
      dateTime: _dateTimeFromJson(json['dateTime']),
      transportType: _typeFromJson(json['transportType'] as String),
      directionFrom: json['directionFrom'] as String,
      direction: json['direction'] as String,
      number: json['number'] as String,
    )..realDateTime = _dateTimeFromJson(json['realDateTime']);

Map<String, dynamic> _$TransportLineItemToJson(TransportLineItem instance) =>
    <String, dynamic>{
      'platformName': instance.platformName,
      'realtimeTripStatus': _statusToJson(instance.realtimeTripStatus),
      'dateTime': _dateTimeToJson(instance.dateTime),
      'realDateTime': _dateTimeToJson(instance.realDateTime),
      'transportType': _typeToJson(instance.transportType),
      'directionFrom': instance.directionFrom,
      'direction': instance.direction,
      'number': instance.number,
    };

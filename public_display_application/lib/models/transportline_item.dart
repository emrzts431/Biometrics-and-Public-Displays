import 'package:json_annotation/json_annotation.dart';

part 'transportline_item.g.dart';

enum TransportStatus { monitored, tripCancelled }

enum TransportType { bus, tram }

TransportStatus _statusFromJson(String status) {
  if (status == "TRIP_CANCELLED") {
    return TransportStatus.tripCancelled;
  } else {
    return TransportStatus.monitored;
  }
}

String _statusToJson(TransportStatus value) =>
    value == TransportStatus.monitored ? "MONITORED" : "TRIP_CANCELLED";

DateTime? _dateTimeFromJson(dynamic datetime) {
  return DateTime(datetime['year'], datetime['month'], datetime['day'],
      datetime['hour'], datetime['minute']);
}

Map<String, dynamic> _dateTimeToJson(DateTime? datetime) => {
      "year": datetime?.year,
      "month": datetime?.month,
      "day": datetime?.day,
      "weekday": datetime?.weekday,
      "hour": datetime?.hour,
      "minute": datetime?.minute
    };

TransportType _typeFromJson(String type) =>
    type == "EVAG Bus" ? TransportType.bus : TransportType.tram;

String _typeToJson(TransportType type) =>
    type == TransportType.bus ? "EVAG Bus" : "EVAG Strab";

@JsonSerializable()
class TransportLineItem {
  String platformName;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  TransportStatus realtimeTripStatus;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? dateTime;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? realDateTime;
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  TransportType transportType;
  String directionFrom;
  String direction;
  String number;

  TransportLineItem({
    required this.platformName,
    required this.realtimeTripStatus,
    required this.dateTime,
    required this.transportType,
    required this.directionFrom,
    required this.direction,
    required this.number,
  });

  factory TransportLineItem.fromJson(Map<String, dynamic> json) =>
      _$TransportLineItemFromJson(json);

  Map<String, dynamic> toJson() => _$TransportLineItemToJson(this);
}

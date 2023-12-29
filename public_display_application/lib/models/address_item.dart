import 'package:json_annotation/json_annotation.dart';
part 'address_item.g.dart';

@JsonSerializable()
class AddressItem {
  String name;
  String address;
  double lat;
  double lon;

  AddressItem({
    required this.address,
    required this.lat,
    required this.lon,
    required this.name,
  });

  factory AddressItem.fromJson(Map<String, dynamic> json) =>
      _$AddressItemFromJson(json);

  Map<String, dynamic> toJson() => _$AddressItemToJson(this);
}

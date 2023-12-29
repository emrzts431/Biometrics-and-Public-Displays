// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressItem _$AddressItemFromJson(Map<String, dynamic> json) => AddressItem(
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AddressItemToJson(AddressItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'lat': instance.lat,
      'lon': instance.lon,
    };

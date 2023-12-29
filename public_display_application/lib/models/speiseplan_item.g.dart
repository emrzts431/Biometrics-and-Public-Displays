// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speiseplan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeisePlanItem _$SpeisePlanItemFromJson(Map<String, dynamic> json) =>
    SpeisePlanItem(
      title: json['title'] as String?,
      title_en: json['title_en'] as String?,
      description: json['description'] as String?,
      description_en: json['description_en'] as String?,
      category: json['category'] as String?,
      category_en: json['category_en'] as String?,
      kennz_gesetzl: json['kennz_gesetzl'] as String?,
      kennz_icons: json['kennz_icons'] as String?,
      kennz_allergen: json['kennz_allergen'] as String?,
      preis1: (json['preis1'] as num?)?.toDouble(),
      preis2: (json['preis2'] as num?)?.toDouble(),
      preis3: (json['preis3'] as num?)?.toDouble(),
      aktion: json['aktion'] as String?,
      nutriscore: json['nutriscore'] as String?,
      foto: json['foto'] as String?,
    );

Map<String, dynamic> _$SpeisePlanItemToJson(SpeisePlanItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'title_en': instance.title_en,
      'description': instance.description,
      'description_en': instance.description_en,
      'category': instance.category,
      'category_en': instance.category_en,
      'kennz_gesetzl': instance.kennz_gesetzl,
      'kennz_icons': instance.kennz_icons,
      'kennz_allergen': instance.kennz_allergen,
      'preis1': instance.preis1,
      'preis2': instance.preis2,
      'preis3': instance.preis3,
      'aktion': instance.aktion,
      'nutriscore': instance.nutriscore,
      'foto': instance.foto,
    };

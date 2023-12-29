import 'package:json_annotation/json_annotation.dart';
part 'speiseplan_item.g.dart';

@JsonSerializable()
class SpeisePlanItem {
  String? title;
  String? title_en;
  String? description;
  String? description_en;
  String? category;
  String? category_en;
  String? kennz_gesetzl;
  String? kennz_icons;
  String? kennz_allergen;
  double? preis1;
  double? preis2;
  double? preis3;
  String? aktion;
  String? nutriscore;
  String? foto;
  SpeisePlanItem({
    this.title,
    this.title_en,
    this.description,
    this.description_en,
    this.category,
    this.category_en,
    this.kennz_gesetzl,
    this.kennz_icons,
    this.kennz_allergen,
    this.preis1,
    this.preis2,
    this.preis3,
    this.aktion,
    this.nutriscore,
    this.foto,
  });

  factory SpeisePlanItem.fromJson(Map<String, dynamic> json) =>
      _$SpeisePlanItemFromJson(json);

  Map<String, dynamic> toJson() => _$SpeisePlanItemToJson(this);

  @override
  String toString() {
    return '''
    SpeisePlan Item | title: $title
    ''';
  }
}

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
  NutritionScores? nutritionScores;
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
    this.nutritionScores,
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

class NutritionScores {
  double? kj;
  double? kcal;
  double? protein;
  double? fat;
  double? transfat;
  double? sugar;
  double? ballastoffe;
  double? salz;
  double? carbonhydrate;

  NutritionScores({
    this.kj,
    this.kcal,
    this.protein,
    this.fat,
    this.transfat,
    this.sugar,
    this.ballastoffe,
    this.salz,
    this.carbonhydrate,
  });
}

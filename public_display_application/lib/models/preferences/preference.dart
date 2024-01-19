import 'package:public_display_application/enums.dart';

class Preference {
  PreferenceTypes type;
  List<String> values = [];
  Preference({required this.type});
}

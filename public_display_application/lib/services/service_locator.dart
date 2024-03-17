import 'package:get_it/get_it.dart';
import 'package:public_display_application/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}

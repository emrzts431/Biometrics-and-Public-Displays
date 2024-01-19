import 'package:flutter/material.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/log_file.dart';
import 'package:public_display_application/models/user.dart';
import 'package:public_display_application/navigation_service.dart';
import 'package:public_display_application/snackbar_holder.dart';

class UserViewModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BuildContext? _homePageContext;

  void setHomePageContext(BuildContext context) => _homePageContext = context;

  Future login(
      int age, String lastname, Genders gender, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      User? localUser =
          await LogFile.of(context).selectUser(lastname, age, gender);
      if (localUser != null) {
        if (await LogFile.of(context).insertSession(
          SessionActionType.start,
          localUser.userid!,
          DateTime.now().microsecondsSinceEpoch,
        )) {
          _user = localUser;
          SnackbarHolder.showSuccessSnackbar(
              'Session wurde erfolgreich startet. Herzlich Wilkommen ${_user!.surname}!',
              context);
        } else {
          SnackbarHolder.showFailureSnackbar(
              'Fehler beim Session starten', context);
        }
        _isLoading = false;
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
      _isLoading = false;
      _user = null;
      SnackbarHolder.showFailureSnackbar('Nutzer existiert nicht', context);
    }
  }

  Future register(
      String surname, int age, Genders gender, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    bool registered =
        await LogFile.of(context).insertUser(surname, age, gender);
    if (registered) {
      try {
        await login(age, surname, gender, context);
      } on Exception catch (e) {
        SnackbarHolder.showFailureSnackbar('Fehler beim registrieren', context);
        print(e);
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  //TODO: GetContentPreferences

  Future signOut() async {
    try {
      if (user != null) {
        _isLoading = true;
        notifyListeners();
        //Log session stop
        if (await LogFile.of(_homePageContext!).insertSession(
            SessionActionType.finish,
            user!.userid!,
            DateTime.now().microsecondsSinceEpoch)) {
          SnackbarHolder.showSuccessSnackbar(
              'Session wurde erfolgreich beendet', _homePageContext!);
          _user = null;
          _isLoading = false;
          _homePageContext = null;
          notifyListeners();
        } else {
          SnackbarHolder.showFailureSnackbar(
              'Fehler beim Session Enden', _homePageContext!);
          _user = null;
          _isLoading = false;
          _homePageContext = null;
          notifyListeners();
        }
      }
    } on Exception catch (e) {
      print(e);
      _user = null;
      _isLoading = false;
      _homePageContext = null;
      notifyListeners();
    }
  }
}

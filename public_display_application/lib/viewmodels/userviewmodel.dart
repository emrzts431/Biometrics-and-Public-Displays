import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/log_file.dart';
import 'package:public_display_application/models/preferences/preference.dart';
import 'package:public_display_application/models/user.dart';
import 'package:public_display_application/services/navigation_service.dart';
import 'package:public_display_application/snackbar_holder.dart';

class UserViewModel extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BuildContext? _homePageContext;

  Preference? _mensaPreference;
  Preference? get mensaPreference => _mensaPreference;

  Preference? _transportPreference;
  Preference? get transportPreference => _transportPreference;
  bool updateTransportLines = false;

  Preference? _weatherPreference;
  Preference? get weatherPreference => _weatherPreference;

  Preference? _mapPreference;
  Preference? get mapPreference => _mapPreference;

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
              '${S.current.sessionSuccessfullyStarted} ${_user!.surname}!',
              context);
        } else {
          SnackbarHolder.showFailureSnackbar(
              S.current.errorAtSessionStart, context);
        }
        _isLoading = false;
      } else {
        _isLoading = false;
        _user = null;
        SnackbarHolder.showFailureSnackbar(S.current.userDoesntExist, context);
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      _isLoading = false;
      _user = null;
      SnackbarHolder.showFailureSnackbar(S.current.userDoesntExist, context);
    }
  }

  Future register(
      String surname, int age, Genders gender, BuildContext context) async {
    //check if the user exists first
    _isLoading = true;
    notifyListeners();
    bool registered =
        await LogFile.of(context).insertUser(surname, age, gender);
    if (registered) {
      try {
        await login(age, surname, gender, context);
      } on Exception catch (e) {
        SnackbarHolder.showFailureSnackbar(S.current.errorAtRegister, context);
        print(e);
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future getPreference(PreferenceTypes type, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    switch (type.index) {
      case 0:
        _mensaPreference =
            await LogFile.of(context).getPreference(type, _user!.userid!);
        print(_mensaPreference);
        break;
      case 1:
        _weatherPreference =
            await LogFile.of(context).getPreference(type, _user!.userid!);
        break;
      case 2:
        _transportPreference =
            await LogFile.of(context).getPreference(type, _user!.userid!);
        break;
      case 3:
        _mapPreference =
            await LogFile.of(context).getPreference(type, _user!.userid!);
        break;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future setPreference(
      PreferenceTypes type, String value, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    await LogFile.of(context)
        .insertPreference(type, _user!.userid!, value)
        .then(
      (value) async {
        if (value) {
          await getPreference(type, context);
        } else {
          SnackbarHolder.showFailureSnackbar(
              S.current.somethingWentWrong, context);
        }
        _isLoading = false;
      },
    );

    notifyListeners();
  }

  Future removePreference(
      PreferenceTypes type, String value, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await LogFile.of(context)
        .removePreference(type, _user!.userid!, value)
        .then((value) async {
      if (value) {
        await getPreference(type, context);
      } else {}
      _isLoading = false;
      notifyListeners();
    });
  }

  Future removeAllPreferencesOfType(
      PreferenceTypes type, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    bool result = await LogFile.of(context)
        .removeAllPreferencesOfType(type, _user!.userid!);
    if (result) {
      await getPreference(type, context);
      _isLoading = false;
      notifyListeners();
    } else {
      SnackbarHolder.showFailureSnackbar(S.current.somethingWentWrong, context);
      _isLoading = false;
      notifyListeners();
    }
  }

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
              S.current.sessionEndedSuccessfully, _homePageContext!);
          _user = null;
          _isLoading = false;
          //_homePageContext = null;
          _mensaPreference = null;
          _weatherPreference = null;
          _mapPreference = null;
          _transportPreference = null;
          await LogFile.of(_homePageContext!).forceDumpInputs();
          notifyListeners();
        } else {
          SnackbarHolder.showFailureSnackbar(
              S.current.errorAtSessionEnd, _homePageContext!);
          _user = null;
          _isLoading = false;
          //_homePageContext = null;
          _mensaPreference = null;
          _weatherPreference = null;
          _mapPreference = null;
          _transportPreference = null;
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

// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Pulic Display Homepage`
  String get publicDisplayTitle {
    return Intl.message(
      'Pulic Display Homepage',
      name: 'publicDisplayTitle',
      desc: '',
      args: [],
    );
  }

  /// `End session`
  String get endSession {
    return Intl.message(
      'End session',
      name: 'endSession',
      desc: '',
      args: [],
    );
  }

  /// `Have your ever used this public display ?`
  String get haveYouEverUsedThisPublicDisplay {
    return Intl.message(
      'Have your ever used this public display ?',
      name: 'haveYouEverUsedThisPublicDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Your age`
  String get yourAge {
    return Intl.message(
      'Your age',
      name: 'yourAge',
      desc: '',
      args: [],
    );
  }

  /// `First three initials of your lastname`
  String get threeInitialsYourName {
    return Intl.message(
      'First three initials of your lastname',
      name: 'threeInitialsYourName',
      desc: '',
      args: [],
    );
  }

  /// `Your first name`
  String get firstName {
    return Intl.message(
      'Your first name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Your last name`
  String get lastName {
    return Intl.message(
      'Your last name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Choose your gender`
  String get chooseYourGender {
    return Intl.message(
      'Choose your gender',
      name: 'chooseYourGender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Non Binary`
  String get nonBinary {
    return Intl.message(
      'Non Binary',
      name: 'nonBinary',
      desc: '',
      args: [],
    );
  }

  /// `Prefer not to say`
  String get preferNotToSay {
    return Intl.message(
      'Prefer not to say',
      name: 'preferNotToSay',
      desc: '',
      args: [],
    );
  }

  /// `Please give all necessary Information`
  String get giveAllNecessaryInfo {
    return Intl.message(
      'Please give all necessary Information',
      name: 'giveAllNecessaryInfo',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `FREE COFFEE`
  String get freeCoffee {
    return Intl.message(
      'FREE COFFEE',
      name: 'freeCoffee',
      desc: '',
      args: [],
    );
  }

  /// `CLICK NOW`
  String get clickNow {
    return Intl.message(
      'CLICK NOW',
      name: 'clickNow',
      desc: '',
      args: [],
    );
  }

  /// `Canteen`
  String get canteen {
    return Intl.message(
      'Canteen',
      name: 'canteen',
      desc: '',
      args: [],
    );
  }

  /// `Transport`
  String get transport {
    return Intl.message(
      'Transport',
      name: 'transport',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message(
      'Map',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `Weather`
  String get weather {
    return Intl.message(
      'Weather',
      name: 'weather',
      desc: '',
      args: [],
    );
  }

  /// `without Pork`
  String get withPork {
    return Intl.message(
      'without Pork',
      name: 'withPork',
      desc: '',
      args: [],
    );
  }

  /// `without Beef`
  String get withBeef {
    return Intl.message(
      'without Beef',
      name: 'withBeef',
      desc: '',
      args: [],
    );
  }

  /// `without Vegan`
  String get vegan {
    return Intl.message(
      'without Vegan',
      name: 'vegan',
      desc: '',
      args: [],
    );
  }

  /// `without Alcohol`
  String get withAlcohol {
    return Intl.message(
      'without Alcohol',
      name: 'withAlcohol',
      desc: '',
      args: [],
    );
  }

  /// `without Poultry`
  String get withPoultry {
    return Intl.message(
      'without Poultry',
      name: 'withPoultry',
      desc: '',
      args: [],
    );
  }

  /// `without Fish`
  String get withFish {
    return Intl.message(
      'without Fish',
      name: 'withFish',
      desc: '',
      args: [],
    );
  }

  /// `without Vegetarian`
  String get vegetarien {
    return Intl.message(
      'without Vegetarian',
      name: 'vegetarien',
      desc: '',
      args: [],
    );
  }

  /// `What is your diet?`
  String get whatIsYourDiet {
    return Intl.message(
      'What is your diet?',
      name: 'whatIsYourDiet',
      desc: '',
      args: [],
    );
  }

  /// `Canteen Menu`
  String get canteenMenu {
    return Intl.message(
      'Canteen Menu',
      name: 'canteenMenu',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sonday`
  String get sonday {
    return Intl.message(
      'Sonday',
      name: 'sonday',
      desc: '',
      args: [],
    );
  }

  /// `Nutritional values`
  String get nutriVals {
    return Intl.message(
      'Nutritional values',
      name: 'nutriVals',
      desc: '',
      args: [],
    );
  }

  /// `Kilocalories`
  String get kiloCals {
    return Intl.message(
      'Kilocalories',
      name: 'kiloCals',
      desc: '',
      args: [],
    );
  }

  /// `Fat`
  String get fat {
    return Intl.message(
      'Fat',
      name: 'fat',
      desc: '',
      args: [],
    );
  }

  /// `saturated`
  String get saturated {
    return Intl.message(
      'saturated',
      name: 'saturated',
      desc: '',
      args: [],
    );
  }

  /// `Carbohydrates`
  String get carbs {
    return Intl.message(
      'Carbohydrates',
      name: 'carbs',
      desc: '',
      args: [],
    );
  }

  /// `Sugar`
  String get sugar {
    return Intl.message(
      'Sugar',
      name: 'sugar',
      desc: '',
      args: [],
    );
  }

  /// `Fiber`
  String get fiber {
    return Intl.message(
      'Fiber',
      name: 'fiber',
      desc: '',
      args: [],
    );
  }

  /// `Protein`
  String get protein {
    return Intl.message(
      'Protein',
      name: 'protein',
      desc: '',
      args: [],
    );
  }

  /// `Salt`
  String get salt {
    return Intl.message(
      'Salt',
      name: 'salt',
      desc: '',
      args: [],
    );
  }

  /// `Per`
  String get per {
    return Intl.message(
      'Per',
      name: 'per',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get students {
    return Intl.message(
      'Students',
      name: 'students',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get staff {
    return Intl.message(
      'Staff',
      name: 'staff',
      desc: '',
      args: [],
    );
  }

  /// `Guests`
  String get guests {
    return Intl.message(
      'Guests',
      name: 'guests',
      desc: '',
      args: [],
    );
  }

  /// `Your Preferences`
  String get yourPreferences {
    return Intl.message(
      'Your Preferences',
      name: 'yourPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Lines`
  String get favoriteLines {
    return Intl.message(
      'Favorite Lines',
      name: 'favoriteLines',
      desc: '',
      args: [],
    );
  }

  /// `Please give your favorite lines for both stops`
  String get pleaseGiveALineForBothStops {
    return Intl.message(
      'Please give your favorite lines for both stops',
      name: 'pleaseGiveALineForBothStops',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Transportation`
  String get transportation {
    return Intl.message(
      'Transportation',
      name: 'transportation',
      desc: '',
      args: [],
    );
  }

  /// `Change Line Preference`
  String get changeLinePreference {
    return Intl.message(
      'Change Line Preference',
      name: 'changeLinePreference',
      desc: '',
      args: [],
    );
  }

  /// `Choose a building`
  String get chooseABuilding {
    return Intl.message(
      'Choose a building',
      name: 'chooseABuilding',
      desc: '',
      args: [],
    );
  }

  /// `Weather Forecast`
  String get weatherForecast {
    return Intl.message(
      'Weather Forecast',
      name: 'weatherForecast',
      desc: '',
      args: [],
    );
  }

  /// `Session has successfully started. Welcome`
  String get sessionSuccessfullyStarted {
    return Intl.message(
      'Session has successfully started. Welcome',
      name: 'sessionSuccessfullyStarted',
      desc: '',
      args: [],
    );
  }

  /// `Error at session start`
  String get errorAtSessionStart {
    return Intl.message(
      'Error at session start',
      name: 'errorAtSessionStart',
      desc: '',
      args: [],
    );
  }

  /// `User doen't exist`
  String get userDoesntExist {
    return Intl.message(
      'User doen\'t exist',
      name: 'userDoesntExist',
      desc: '',
      args: [],
    );
  }

  /// `Error at register`
  String get errorAtRegister {
    return Intl.message(
      'Error at register',
      name: 'errorAtRegister',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Session ended successfully`
  String get sessionEndedSuccessfully {
    return Intl.message(
      'Session ended successfully',
      name: 'sessionEndedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `There was an error at session ending`
  String get errorAtSessionEnd {
    return Intl.message(
      'There was an error at session ending',
      name: 'errorAtSessionEnd',
      desc: '',
      args: [],
    );
  }

  /// `Are you still there ?`
  String get areYouStillThere {
    return Intl.message(
      'Are you still there ?',
      name: 'areYouStillThere',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to end your session? You will lose your chance to get a free coffee if you go now!`
  String get sureToEndSession {
    return Intl.message(
      'Are you sure to end your session? You will lose your chance to get a free coffee if you go now!',
      name: 'sureToEndSession',
      desc: '',
      args: [],
    );
  }

  /// `This work is conducted by the HCI Team supervised by Prof. Dr. Stefan Schneegaß`
  String get workConducted {
    return Intl.message(
      'This work is conducted by the HCI Team supervised by Prof. Dr. Stefan Schneegaß',
      name: 'workConducted',
      desc: '',
      args: [],
    );
  }

  /// `Post-Study Questionnaire`
  String get susForm {
    return Intl.message(
      'Post-Study Questionnaire',
      name: 'susForm',
      desc: '',
      args: [],
    );
  }

  /// `Go to SUS form`
  String get gotoSusForm {
    return Intl.message(
      'Go to SUS form',
      name: 'gotoSusForm',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get show {
    return Intl.message(
      'Show',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `unknown`
  String get unknown {
    return Intl.message(
      'unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get goBack {
    return Intl.message(
      'Back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

enum PreferenceTypes { mensa, weather, transport, map }

enum SessionActionType { finish, start }

enum Genders { male, female, nonbinary, nan }

enum Buttons {
  returningUser, //0
  newUser, //1
  login, //2
  register, //3
  male, //4
  female, //5
  nonBinary, //6
  preferNotToSay, //7

  canteen, //8
  mensaListTile, //9
  mensaAddFilter, //10
  mensaFilter, //11
  dateNextDay, //12
  datePrevDay, //13
  deleteMensaFilter, //14

  transport, //15
  lineSelection, //16
  save, //17
  changeLinePrefs, //18

  map, //19
  mapOption, //20

  weather, //21

  endSession, //22
  endSessionYes, //23

  areYouStillThere, //24
  goBackHomePage, //25
  goBackRegisterPage, //26

  exitSUS, //27
  goSUS //28
}

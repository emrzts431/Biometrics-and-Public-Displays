import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/events/button_click_event.dart';
import 'package:public_display_application/events/pd_event_bus.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/snackbar_holder.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _ageInputController = TextEditingController();
  final _lastnameInputController = TextEditingController();
  final _firstnameInputController = TextEditingController();
  Genders? selectedGender;
  VirtualKeyboardType keyBoardType = VirtualKeyboardType.Numeric;
  bool _firstName = false;
  bool openKeyboard = false;

  bool? returningUser;
  @override
  Widget build(BuildContext context) {
    if (returningUser == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).haveYouEverUsedThisPublicDisplay,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  PDEventBus()
                      .fire(ButtonClickedEvent(Buttons.returningUser.index));
                  setState(() => returningUser = true);
                },
                child: Text(S.of(context).yes),
              ),
              const SizedBox(
                width: 80,
              ),
              ElevatedButton(
                onPressed: () {
                  PDEventBus().fire(ButtonClickedEvent(Buttons.newUser.index));
                  setState(() => returningUser = false);
                },
                child: Text(S.of(context).no),
              ),
            ],
          )
        ],
      );
    } else {
      if (returningUser!) {
        return returningUserWidget();
      } else {
        return newUserWidget();
      }
    }
  }

  Widget returningUserWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          onTap: () => setState(() {
            keyBoardType = VirtualKeyboardType.Numeric;
            openKeyboard = true;
          }),
          onEditingComplete: () => setState(() {
            openKeyboard = false;
          }),
          style: const TextStyle(fontSize: 25),
          maxLength: 2,
          controller: _ageInputController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: S.of(context).yourAge,
              hintStyle: const TextStyle(fontSize: 25)),
        ),
        TextField(
          onTap: () => setState(() {
            keyBoardType = VirtualKeyboardType.Alphanumeric;
            openKeyboard = true;
          }),
          onEditingComplete: () => setState(() {
            openKeyboard = false;
          }),
          style: const TextStyle(fontSize: 25),
          maxLength: 3,
          controller: _lastnameInputController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: S.of(context).threeInitialsYourName,
            hintStyle: const TextStyle(fontSize: 25),
          ),
        ),
        DropdownButton<Genders>(
          hint: Text(S.of(context).chooseYourGender),
          value: selectedGender,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (Genders? newValue) {
            setState(() {
              selectedGender = newValue;
            });
            switch (newValue) {
              case Genders.male:
                PDEventBus().fire(ButtonClickedEvent(Buttons.male.index));
              case Genders.female:
                PDEventBus().fire(ButtonClickedEvent(Buttons.female.index));
              case Genders.nonbinary:
                PDEventBus().fire(ButtonClickedEvent(Buttons.nonBinary.index));
              case Genders.nan:
                PDEventBus()
                    .fire(ButtonClickedEvent(Buttons.preferNotToSay.index));
              default:
                PDEventBus().fire(ButtonClickedEvent(Buttons.male.index));
            }
          },
          items: [
            DropdownMenuItem<Genders>(
              value: Genders.male,
              child: Text(S.of(context).male),
            ),
            DropdownMenuItem<Genders>(
              value: Genders.female,
              child: Text(S.of(context).female),
            ),
            DropdownMenuItem<Genders>(
              value: Genders.nonbinary,
              child: Text(S.of(context).nonBinary),
            ),
            DropdownMenuItem<Genders>(
              value: Genders.nan,
              child: Text(
                S.of(context).preferNotToSay,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        if (context.watch<UserViewModel>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (!context.watch<UserViewModel>().isLoading)
          ElevatedButton(
            onPressed: () async {
              PDEventBus().fire(ButtonClickedEvent(Buttons.login.index));
              if (_ageInputController.text.isEmpty ||
                  _lastnameInputController.text.isEmpty ||
                  selectedGender == null) {
                SnackbarHolder.showFailureSnackbar(
                    S.of(context).giveAllNecessaryInfo, context);
              } else {
                await context.read<UserViewModel>().login(
                      int.parse(_ageInputController.text),
                      _lastnameInputController.text,
                      selectedGender!,
                      context,
                    );
              }
            },
            child: Text(
              S.of(context).login,
            ),
          ),
        const SizedBox(
          height: 50,
        ),
        if (openKeyboard) virtualKeyboard(),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            PDEventBus()
                .fire(ButtonClickedEvent(Buttons.goBackRegisterPage.index));
            setState(
              () {
                _ageInputController.text = "";
                _lastnameInputController.text = "";
                returningUser = null;
                openKeyboard = false;
              },
            );
          },
          child: Text(S.of(context).goBack),
        ),
      ],
    );
  }

  Widget newUserWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          onTap: () => setState(() {
            keyBoardType = VirtualKeyboardType.Numeric;
            openKeyboard = true;
          }),
          onEditingComplete: () => setState(() {
            openKeyboard = false;
          }),
          style: const TextStyle(fontSize: 25),
          maxLength: 2,
          controller: _ageInputController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: S.of(context).yourAge,
              hintStyle: const TextStyle(fontSize: 25)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                onTap: () => setState(() {
                  keyBoardType = VirtualKeyboardType.Alphanumeric;
                  _firstName = true;
                  openKeyboard = true;
                }),
                onEditingComplete: () => setState(() {
                  openKeyboard = false;
                }),
                style: const TextStyle(fontSize: 25),
                controller: _firstnameInputController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: S.of(context).firstName,
                  hintStyle: const TextStyle(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                onTap: () => setState(() {
                  keyBoardType = VirtualKeyboardType.Alphanumeric;
                  _firstName = false;
                  openKeyboard = true;
                }),
                onEditingComplete: () => setState(() {
                  openKeyboard = false;
                }),
                style: const TextStyle(fontSize: 25),
                controller: _lastnameInputController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: S.of(context).lastName,
                  hintStyle: const TextStyle(fontSize: 25),
                ),
              ),
            ),
          ],
        ),
        DropdownButton<Genders>(
          hint: Text(S.of(context).chooseYourGender),
          value: selectedGender,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (Genders? newValue) {
            setState(() {
              selectedGender = newValue;
            });
            switch (newValue) {
              case Genders.male:
                PDEventBus().fire(ButtonClickedEvent(Buttons.male.index));
              case Genders.female:
                PDEventBus().fire(ButtonClickedEvent(Buttons.female.index));
              case Genders.nonbinary:
                PDEventBus().fire(ButtonClickedEvent(Buttons.nonBinary.index));
              case Genders.nan:
                PDEventBus()
                    .fire(ButtonClickedEvent(Buttons.preferNotToSay.index));
              default:
                PDEventBus().fire(ButtonClickedEvent(Buttons.male.index));
            }
          },
          items: [
            DropdownMenuItem<Genders>(
              value: Genders.male,
              child: Text(S.of(context).male),
            ),
            DropdownMenuItem<Genders>(
              value: Genders.female,
              child: Text(S.of(context).female),
            ),
            DropdownMenuItem<Genders>(
              value: Genders.nonbinary,
              child: Text(S.of(context).nonBinary),
            ),
            DropdownMenuItem<Genders>(
              value: Genders.nan,
              child: Text(
                S.of(context).preferNotToSay,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        if (context.watch<UserViewModel>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (!context.watch<UserViewModel>().isLoading)
          ElevatedButton(
            onPressed: () async {
              PDEventBus().fire(ButtonClickedEvent(Buttons.register.index));
              if (_ageInputController.text.isEmpty ||
                  _lastnameInputController.text.isEmpty ||
                  selectedGender == null) {
                SnackbarHolder.showFailureSnackbar(
                    S.of(context).giveAllNecessaryInfo, context);
              } else {
                await context.read<UserViewModel>().register(
                      _firstnameInputController.text,
                      _lastnameInputController.text,
                      int.parse(_ageInputController.text),
                      selectedGender!,
                      context,
                    );
              }
            },
            child: Text(
              S.of(context).register,
            ),
          ),
        const SizedBox(
          height: 50,
        ),
        if (openKeyboard) virtualKeyboard(),
        const SizedBox(
          height: 70,
        ),
        ElevatedButton(
          onPressed: () => setState(
            () {
              _ageInputController.text = "";
              _lastnameInputController.text = "";
              selectedGender = null;
              returningUser = null;
              openKeyboard = false;
            },
          ),
          child: Text(S.of(context).goBack),
        ),
        if (context.watch<UserViewModel>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }

  VirtualKeyboard virtualKeyboard() {
    return VirtualKeyboard(
      alwaysCaps: true,
      type: keyBoardType,
      height: 270,
      width: 600,
      fontSize: 25,
      defaultLayouts: const [VirtualKeyboardDefaultLayouts.English],
      onKeyPress: (VirtualKeyboardKey key) => setState(() {
        if (keyBoardType == VirtualKeyboardType.Numeric) {
          if (key.action == VirtualKeyboardKeyAction.Backspace) {
            if (_ageInputController.text.isNotEmpty) {
              _ageInputController.text = _ageInputController.text
                  .substring(0, _ageInputController.text.length - 1);
            }
          } else {
            if (_ageInputController.text.length < 2 && key.text != '.') {
              _ageInputController.text += key.text?.toUpperCase() ?? '';
            }
          }
        } else {
          if (key.action == VirtualKeyboardKeyAction.Backspace) {
            if (_firstName) {
              if (_firstnameInputController.text.isNotEmpty) {
                _firstnameInputController.text = _firstnameInputController.text
                    .substring(0, _firstnameInputController.text.length - 1);
              }
            } else {
              if (_lastnameInputController.text.isNotEmpty) {
                _lastnameInputController.text = _lastnameInputController.text
                    .substring(0, _lastnameInputController.text.length - 1);
              }
            }
          } else {
            if (_firstName) {
              _firstnameInputController.text += key.text?.toUpperCase() ?? '';
            } else {
              _lastnameInputController.text += key.text?.toUpperCase() ?? '';
            }
          }
        }
      }),
    );
  }
}

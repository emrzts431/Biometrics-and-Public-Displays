import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
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
  String? selectedGender;
  VirtualKeyboardType keyBoardType = VirtualKeyboardType.Numeric;
  bool openKeyboard = false;

  bool? returningUser;
  @override
  Widget build(BuildContext context) {
    if (returningUser == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Hast du das Public Display schon benutzt ?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => returningUser = true),
                child: Text("Ja"),
              ),
              const SizedBox(
                width: 80,
              ),
              ElevatedButton(
                onPressed: () => setState(() => returningUser = false),
                child: const Text("Nein"),
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
          decoration: const InputDecoration(
              hintText: "Dein alter", hintStyle: TextStyle(fontSize: 25)),
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
          decoration: const InputDecoration(
            hintText: "Erste 3 Buschtaben deiner Nachname",
            hintStyle: TextStyle(fontSize: 25),
          ),
        ),
        DropdownButton<String>(
          hint: const Text("Wähle dein Geschlecht aus"),
          value: selectedGender,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
          items: <String>['Männlich', 'Weiblich']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_ageInputController.text.isEmpty ||
                _lastnameInputController.text.isEmpty) {
              SnackbarHolder.showFailureSnackbar(
                  "Bitte alle nötige Informationen eingeben", context);
            } else {
              await context.read<UserViewModel>().login(
                    int.parse(_ageInputController.text),
                    _lastnameInputController.text,
                    selectedGender! == 'Männlich'
                        ? Genders.male
                        : Genders.female,
                    context,
                  );
            }
          },
          child: const Text(
            "GO!",
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
          onPressed: () => setState(
            () {
              _ageInputController.text = "";
              _lastnameInputController.text = "";
              returningUser = null;
              openKeyboard = false;
            },
          ),
          child: const Text('Zurück'),
        ),
        if (context.watch<UserViewModel>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
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
          decoration: const InputDecoration(
              hintText: "Dein alter", hintStyle: TextStyle(fontSize: 25)),
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
          decoration: const InputDecoration(
            hintText: "Erste 3 Buschtaben deiner Nachname",
            hintStyle: TextStyle(fontSize: 25),
          ),
        ),
        DropdownButton<String>(
          hint: const Text("Wähle dein Geschlecht aus"),
          value: selectedGender,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue;
            });
          },
          items: <String>['Männlich', 'Weiblich']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_ageInputController.text.isEmpty ||
                _lastnameInputController.text.isEmpty ||
                selectedGender == null) {
              SnackbarHolder.showFailureSnackbar(
                  "Bitte alle nötige Informationen eingeben", context);
            } else {
              await context.read<UserViewModel>().register(
                    _lastnameInputController.text,
                    int.parse(_ageInputController.text),
                    selectedGender! == 'Männlich'
                        ? Genders.male
                        : Genders.female,
                    context,
                  );
            }
          },
          child: const Text(
            "Registrieren!",
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
          child: const Text('Zurück'),
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
            if (_lastnameInputController.text.isNotEmpty) {
              _lastnameInputController.text = _lastnameInputController.text
                  .substring(0, _lastnameInputController.text.length - 1);
            }
          } else {
            if (_lastnameInputController.text.length < 3) {
              _lastnameInputController.text += key.text?.toUpperCase() ?? '';
            }
          }
        }
      }),
    );
  }
}

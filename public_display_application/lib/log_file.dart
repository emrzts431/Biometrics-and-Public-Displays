import 'dart:io';

import 'package:flutter/material.dart';

class LogFile extends InheritedWidget {
  final File logFile;

  LogFile({required this.logFile, required Widget mychild})
      : super(child: mychild);

  static LogFile of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<LogFile>() as LogFile;
  bool updateShouldNotify(LogFile oldWidget) {
    return oldWidget.logFile != logFile;
  }
}

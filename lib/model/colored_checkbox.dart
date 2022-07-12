import 'dart:math' show Random;

import 'package:flutter/material.dart';

enum EnumColor { red, blue, green }

class ColoredCheckbox {
  EnumColor colorValue;

  bool selectedValue = false;
  bool oneMoreSelected = false;

  ColoredCheckbox(this.colorValue);
  static final colors = {
    EnumColor.red: Colors.red[300],
    EnumColor.blue: Colors.blue[300],
    EnumColor.green: Colors.green[300],
  };

  Color? get color => colors[colorValue];

  bool checkValue(EnumColor tapColor) {
    switch (tapColor) {
      case EnumColor.green:
        return selectedValue = true;
      case EnumColor.red:
        return selectedValue = true;
      case EnumColor.blue:
        return selectedValue = true;
      default:
        return selectedValue = false;
    }
  }

  EnumColor get random =>
      EnumColor.values[Random().nextInt(EnumColor.values.length)];
}

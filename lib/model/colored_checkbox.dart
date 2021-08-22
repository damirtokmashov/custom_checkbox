import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'dart:ui' show Color;

enum EnumColor { red, blue, green }

class ColoredCheckbox {
  EnumColor colorValue;

  bool selectedValue = false;
  bool oneMoreSelected = false;

  ColoredCheckbox(this.colorValue);
  static const colors = {
    EnumColor.red: Colors.red,
    EnumColor.blue: Colors.blue,
    EnumColor.green: Colors.green,
  };

  Color? get color => colors[colorValue];

  bool? checkValue(EnumColor tapColor) {
    switch (tapColor) {
      case EnumColor.green:
        selectedValue = true;
        break;
      case EnumColor.red:
        selectedValue = true;
        break;
      case EnumColor.blue:
        selectedValue = true;
        break;
      default:
        selectedValue = false;
    }
  }

  static EnumColor get random =>
      EnumColor.values[Random().nextInt(EnumColor.values.length)];
}

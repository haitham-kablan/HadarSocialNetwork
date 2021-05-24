

import 'package:flutter/widgets.dart';
import 'dart:ui';

class HebrewText extends Text{
  HebrewText(String data) : super(data, textDirection: TextDirection.rtl,
    style: TextStyle(fontFamily: "David"),);

}
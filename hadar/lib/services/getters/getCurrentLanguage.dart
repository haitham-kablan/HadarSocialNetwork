import 'package:flutter/cupertino.dart';

import '../../main.dart';

getLanguage(BuildContext context) {
  String language = MainApp.of(context).getLanguage();
  String langCode;
  switch (language) {
    case "עברית":
      langCode = "he";
      break;
    case "العربية":
      langCode = "ar";
      break;
    case "English":
      langCode = "en";
      break;
    case "русский":
      langCode = "ru";
      break;
    default:
      langCode = "he";
  }
  return langCode;
}
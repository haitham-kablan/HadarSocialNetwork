

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/main.dart';
import 'package:hadar/services/DataBaseServices.dart';

class ChangeLangDialogue extends StatelessWidget{
  final String userId;

  ChangeLangDialogue(this.userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 200,
      child: DropdownButton<String>(
        items: <String>['עברית', 'العربية', 'English', 'русский'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (String newLang) {
          String langCode;
          switch(newLang){
            case "עברית": langCode = "he"; break;
            case "العربية": langCode = "ar"; break;
            case "English": langCode = "en"; break;
            case "русский": langCode = "ru"; break;
            default: langCode = "he";
          }
          DataBaseService().setUserAppLanguage(userId, langCode);
          MainApp.of(context).setLocale(Locale.fromSubtags(languageCode: langCode));
        },
      ),
    );
  }


}
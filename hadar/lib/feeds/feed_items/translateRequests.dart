import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/profiles/profileItems/basicItemsForAllProfiles.dart';
import 'package:translator/translator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../main.dart';


class TranslateRequest extends StatefulWidget {
  String category;
  String description;
  TranslateRequest(this.category,this.description);
  // const TranslateRequest({Key key}) : super(key: key);

  @override
  _TranslateRequestState createState() => _TranslateRequestState(category,description);
}

class _TranslateRequestState extends State<TranslateRequest> {
  ProfileButton buttonCreate = ProfileButton();
  final translator = GoogleTranslator();
  String category;
  var categoryTranslation;
  String description;
  var descriptionTranslation;
  bool showTranslation = true;
  bool showOriginal = false;
  _TranslateRequestState(this.category
      ,this.description);


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

  initText() async {
    String newLang = getLanguage(context);
    try {
      categoryTranslation = await translator.translate(
        category,
        to: newLang,
      );
      descriptionTranslation =
      await translator.translate(description, to: newLang);
    } catch (e) {
      if ('en' != newLang)
        newLang = 'en';
      else
        newLang = 'he';
      categoryTranslation = await translator.translate(
        category,
        to: newLang,
      );
      descriptionTranslation = await translator.translate(
        description,
        to: newLang,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initText();
    ButtonStyle style = buttonCreate.getStyle(context);
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Visibility(
                  visible: showTranslation,
                  child: Text(category),
                ),
                Visibility(
                  visible: showOriginal,
                  child: Text(categoryTranslation.toString()),
                ),
              ]),
              Visibility(
                visible: showTranslation,
                child: Text(description),
              ),
              Visibility(
                visible: showOriginal,
                child: Text(descriptionTranslation.toString()),
              ),
              Visibility(
                visible: showTranslation,
                child: TextButton(
                  child: buttonCreate.getChild(
                      AppLocalizations.of(context).translate, Icons.translate),
                  style: style,
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 800), () {
                      setState(() {
                        showTranslation = false;
                        showOriginal = true;
                      });
                    });
                  },
                ),
              ),
              Visibility(
                visible: showOriginal,
                child: TextButton(
                  child: buttonCreate.getChild(
                      AppLocalizations.of(context).showOriginal, Icons.translate),
                  style: style,
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 800), () {
                      setState(() {
                        showTranslation = true;
                        showOriginal = false;
                      });
                    });
                  },
                ),
              )
            ]));
  }
}

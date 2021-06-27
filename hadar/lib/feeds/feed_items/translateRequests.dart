import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/profiles/profileItems/basicItemsForAllProfiles.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:translator/translator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../main.dart';
import '../adminfeedtile.dart';

class TranslateRequest extends StatefulWidget {
  bool adminFeed;
  HelpRequest helpRequest;
  String feedType;

  TranslateRequest(this.helpRequest, this.feedType);

  // const TranslateRequest({Key key}) : super(key: key);

  @override
  _TranslateRequestState createState() =>
      _TranslateRequestState(this.helpRequest, feedType);
}

class _TranslateRequestState extends State<TranslateRequest> {
  HelpRequest helpRequest;
  ProfileButton buttonCreate = ProfileButton();
  final translator = GoogleTranslator();
  String category;
  var categoryTranslation;
  String description;
  var descriptionTranslation;
  bool showTranslation = true;
  bool showOriginal = false;
  String feedType;

  _TranslateRequestState(this.helpRequest, this.feedType);

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
    category = helpRequest.category.description;
    description = helpRequest.description;
    String newLang = getLanguage(context);
    try {
      categoryTranslation = await translator.translate(
        category,
        to: newLang,
      );
    } catch (e) {
      if ('en' != newLang)
        newLang = 'en';
      else
        newLang = 'he';
      categoryTranslation = await translator.translate(
        category,
        to: newLang,
      );
    }
    try {
      descriptionTranslation =
          await translator.translate(description, to: newLang);
    } catch (e) {
      if ('en' != newLang)
        newLang = 'en';
      else
        newLang = 'he';
      descriptionTranslation = await translator.translate(
        description,
        to: newLang,
      );
    }
  }

  adminFeedOrHelperFeed() {
    if (feedType == 'adminVerified') {
      return Container();
    }
    if (feedType == 'helperFeed') {
      return helpRequest.handler_id == ''
          ? ThreeDotsWidget(helpRequest)
          : Container();
    }
    if (feedType == 'adminRequest') {
      return CallWidget(widget.helpRequest);
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
          // adminFeedOrHelperFeed(),
          Row(children: <Widget>[
            Visibility(
              visible: showTranslation,
              child: Text(category),
            ),
            Visibility(
              visible: showOriginal,
              child: Text(categoryTranslation.toString()),
            ),
            Spacer(),
            Spacer(),
            adminFeedOrHelperFeed(),
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

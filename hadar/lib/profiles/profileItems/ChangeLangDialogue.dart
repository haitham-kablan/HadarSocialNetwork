import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/main.dart';
import 'package:hadar/profiles/adminProfile.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../profile.dart';

class ChangeLangDialogue extends StatelessWidget {
  final String privilege;
  final bool userIsLoggedIn;
  ChangeLangDialogue(this.privilege,{this.userIsLoggedIn = true});

  @override
  Widget build(BuildContext context) {
    String userEmail = CurrentUser.curr_user.email;
    return new AlertDialog(
      title: Center(child: Text(AppLocalizations.of(context).changeLanguage, style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
      backgroundColor: BasicColor.backgroundClr,
      actions: [
        Container(
          child: Center(
            child: DropdownButton<String>(
              items: <String>['עברית', 'العربية', 'English'/*, 'русский'*/]
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: new Text(value, style: TextStyle(fontSize: 18),)),
                );
              }).toList(),
              value: MainApp.of(context).getLanguage(),
              onChanged: (String newLang) {
                String langCode;
                switch (newLang) {
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
                MainApp.of(context)
                    .setLocale(Locale.fromSubtags(languageCode: langCode));
                Navigator.pop(context);
                if(userIsLoggedIn) {
                  DataBaseService().setUserAppLanguage(userEmail, langCode);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          if (privilege != 'Admin') {
                            return ProfilePage(CurrentUser.curr_user);
                          }
                          return AdminProfile(CurrentUser.curr_user);
                        }
                    ),
                  );
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogInPage()
                    ),
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

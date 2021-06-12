import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hadar/services/getters/GetCurrentUser.dart';

import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const double marginSize = kIsWeb ? 0.0 : 0.0;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      //const Locale('en', ''), // English, no country code
      const Locale('ar', ''), // Arabic, no country code
      const Locale('he', ''), // Hebrew, no country code
      //const Locale('ru', ''), // Russian, no country code
    ],
    locale: Locale.fromSubtags(languageCode: 'he'),
    home: Container(
      margin: const EdgeInsets.only(left: marginSize, right: marginSize),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetCurrentUser(),
      ),
    ),
  ));
}


// useless line to check the flutter CI


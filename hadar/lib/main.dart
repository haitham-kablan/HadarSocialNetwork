

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/HelpRequestAdminDialouge.dart';
import 'package:hadar/main_pages/UserInNeedPage.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';
import 'package:hadar/services/authentication/forms/UserInNeedRegPage.dart';

import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'lang/HebrewText.dart';
import 'main_pages/AdminPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const double marginSize = kIsWeb ? 300.0 : 0.0;
  runApp(MaterialApp(
    home: Container(
        margin: const EdgeInsets.only(left: marginSize, right: marginSize),
        child: LogInPage(),
    ),
  ));
}



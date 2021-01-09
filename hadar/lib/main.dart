import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/HelpRequestAdminDialouge.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';
import 'package:hadar/services/authentication/google_sign_in_button.dart';
import 'package:hadar/services/authentication/provider/google_sign_in_provider.dart';

import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'lang/HebrewText.dart';
import 'main_pages/AdminPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Widget curr_user_page = await CurrentUser.init_user();
  DataBaseService().add_user_token_to_db();

  runApp(MaterialApp(
    home: curr_user_page == null ? LogInPage() : curr_user_page,
    debugShowCheckedModeBanner: false,
  ));
}


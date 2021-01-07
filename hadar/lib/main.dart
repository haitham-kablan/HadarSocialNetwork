import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/HelpRequestAdminDialouge.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';

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

  runApp(MaterialApp(
    home: curr_user_page == null ? LogInPage() : curr_user_page,
  ));
}



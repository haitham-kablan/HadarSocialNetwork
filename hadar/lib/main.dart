import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';
import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'lang/HebrewText.dart';
import 'main_pages/AdminPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: LogInPage(),
  ));
}

class demo_bg extends StatelessWidget {
  Widget son;
  demo_bg(this.son);
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
      Container(

      color: Colors.transparent,
      child: new Container(
        padding: EdgeInsets.only(bottom: 50),
          decoration: new BoxDecoration(
              color: BasicColor.clr,
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(150),
                bottomRight: const Radius.circular(150),
              )
          ),
          child: son,
      ),
    ),

      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/HelpRequestAdminDialouge.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';

import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
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

//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: tmp(),
//   ));
// }
//
//
// class tmp extends StatefulWidget {
//   @override
//   _tmpState createState() => _tmpState();
// }
//
// class _tmpState extends State<tmp> {
//   @override
//   Widget build(BuildContext context) {
//     String long = '2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222';
//     return Container(
//       child: RaisedButton(
//         child: Text('click me'),
//         onPressed: (){
//           HelpRequestAdminDialuge(context, HelpRequest(HelpRequestType('בועז'), long, DateTime.now(), 'sender_id', 'handler_id'));
//         },
//       ),
//     );
//   }
// }

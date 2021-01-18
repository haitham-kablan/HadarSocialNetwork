

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hadar/users/Annoymous_user.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   const double marginSize = kIsWeb ? 0.0 : 0.0;
//   runApp(MaterialApp(
//     home: Container(
//         margin: const EdgeInsets.only(left: marginSize, right: marginSize),
//         child: Scaffold(
//           body: LogInPage(),
//         ),
//     ),
//   ));
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const double marginSize = kIsWeb ? 0.0 : 0.0;
  runApp(MaterialApp(
    home: Center(
      child: RaisedButton(
        onPressed: () {
          DataBaseService().addHelpRequestToDataBaseForUserInNeedAsAdmin(HelpRequest(HelpRequestType('k3k'), 'description', DateTime.now(), '123', '', Status.AVAILABLE), Annoymous_user('name', 'phoneNumber', 'email', false, 'id'));
        },
        child: Text('click me'),
      ),

    ),
  ));
}







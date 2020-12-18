import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/Buttons/RoundedWeightedButtons.dart';
import 'package:hadar/Design/basicTools.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/users/RegisteredUser.dart';
import 'package:hadar/users/User.dart';


import 'package:firebase_core/firebase_core.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //User curr_user = await DataBaseService().getCurrentUser();


  runApp(MaterialApp(
    home: curr_user == null ? LogInPage() : weork_right(),
  ));
}

class weork_right extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('sssssssssssssssssssssssssssssss'),
    );
  }
}




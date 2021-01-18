

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const double marginSize = kIsWeb ? 0.0 : 0.0;
  runApp(MaterialApp(
    home: Container(
        margin: const EdgeInsets.only(left: marginSize, right: marginSize),
        child: Scaffold(
          body: LogInPage(),
        ),
    ),
  ));
}



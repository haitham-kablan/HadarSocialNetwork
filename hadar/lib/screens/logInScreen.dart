
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/screens/appBarCustom/customed_appBar.dart';

import 'appBarCustom/DecorationBoxes.dart';

import 'buttons/buttonClass.dart';


class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipPath(
            clipper: CustomAppBar(),
            child:Container(
              decoration: Decorations_Boxes().app_bar_decation(),
            ),
          ),
        ),

      ),
      body: Container(
        child: my_Buttons().helpButton(),
        alignment: Alignment.topCenter,
        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      )
    );

  }
}

import 'package:flutter/material.dart';
import 'package:hadar/screens/appBarCustom/DecorationBoxes.dart';


class my_Buttons extends ElevatedButton {

  ElevatedButton helpButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: Colors.deepPurple

      ),
      child: Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        decoration: Decorations_Boxes().HelpButtonDecoration(),
        child: Text(
          'HELP',
          style: TextStyle(fontSize: 40),
        ),
      ),
      onPressed: () {},
    );
  }
}

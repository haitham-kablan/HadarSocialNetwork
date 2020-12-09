import 'package:flutter/material.dart';

class Decorations_Boxes extends BoxDecoration{

  BoxDecoration app_bar_decation(){
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.purpleAccent,Colors.purple[100]],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            tileMode: TileMode.clamp
        )
    );
  }

  BoxDecoration HelpButtonDecoration(){
    return BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            colors: [Colors.purpleAccent[100],Colors.purple],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            tileMode: TileMode.clamp,
        )
    );
  }
}

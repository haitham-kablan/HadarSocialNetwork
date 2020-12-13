import 'package:flutter/material.dart';
import 'package:hadar/screens/logInScreen.dart';

import 'Design/mainDesign.dart';


class TmpClass extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(backgroundColor: Colors.transparent,);
  }
}

class stackedPages extends StatelessWidget {
  Widget page;
  stackedPages(this.page);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundDesign()
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: stackedPages(TmpClass()),
  ));
}

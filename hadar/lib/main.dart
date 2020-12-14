import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';

import 'Design/mainDesign.dart';


class TmpClass extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(backgroundColor: BasicColor.BackgroundClr,);
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
          page,
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

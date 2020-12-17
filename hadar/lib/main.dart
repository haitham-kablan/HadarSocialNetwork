import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';

import 'Design/mainDesign.dart';

class TmpClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColor.backgroundClr,
      body: Container(margin: EdgeInsets.fromLTRB(0, 250, 0, 70),),
    );
  }
}

class stackedPages extends StatelessWidget {
  Widget page;

  stackedPages(this.page);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [page, BackgroundDesign()],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: stackedPages(TmpClass()),
  ));
  // runApp(
  //   MaterialApp(
  //     home: Scaffold(
  //       // appBar: BarDesign(BasicColor.HelperClr, 'User Feed'),
  //       bottomNavigationBar: BottomBar(BasicColor.HelperClr),
  //     ),
  //   ),
  // );
}

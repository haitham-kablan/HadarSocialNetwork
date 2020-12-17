import 'dart:ui';
import 'basicTools.dart';
import 'package:flutter/material.dart';

//when using this, send the color you want to use
//see example in BackgroundDesign class
class BarDesign extends StatelessWidget {
  String title;

  BarDesign(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 250),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              color: BasicColor.clr,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60)),
            ),
            child: Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(0, 40, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'שלום חנין',
                    // this.title,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//when using this, send the color you want to use
//see example in BackgroundDesign class
//the icons aren't linked to another page yet
class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(-3, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.dynamic_feed_outlined,
                      size: 40,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.add_rounded,
                      size: 40,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BarCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/barPic.png',
              width: 180,
              height: 180,
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundDesign extends StatelessWidget {
//todo: change the color depending on the user type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BarDesign('User Feed'),
          BottomBar(),
          BarCircle(),
        ],
      ),
    );
  }
}

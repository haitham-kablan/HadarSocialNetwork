import 'dart:ui';
import 'basicTools.dart';
import 'package:flutter/material.dart';

class ButtonDesign extends StatelessWidget {
  double width;
  double height;

  ButtonDesign(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(73.0),
        color: const Color(0xffe9eaef),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff6974da),
            offset: Offset(9, 9),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}

//when using this, send the color you want to use
//see example in BackgroundDesign class
class BarDesign extends StatelessWidget {
  Color usedClr;
  String title;

  BarDesign(this.usedClr, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColor.BackgroundClr,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 150),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: usedClr,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: usedClr,
                  offset: Offset(9, 9),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(150, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.title,
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(),
    );
  }
}

//when using this, send the color you want to use
//see example in BackgroundDesign class
//the icons aren't linked to another page yet
class BottomBar extends StatelessWidget {
  Color usedClr;

  BottomBar(this.usedClr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              color: BasicColor.FillClr,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: usedClr,
                  offset: Offset(-9, -9),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: usedClr,
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.dynamic_feed_outlined,
                      size: 40,
                      color: usedClr,
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.add_rounded,
                      size: 40,
                      color: usedClr,
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

class UserCircle extends StatelessWidget {
  Color usedClr;

  UserCircle(this.usedClr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          //Container(height: 20, width: 50),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: Alignment.topLeft,
            width: 150,
            height: 135,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(73.0),
              color: BasicColor.FillClr,
              boxShadow: [
                BoxShadow(
                  color: usedClr,
                  offset: Offset(9, 9),
                  blurRadius: 6,
                ),
              ],
            ),
          )
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          BarDesign(BasicColor.HelperClr, 'User Feed'),
          UserCircle(BasicColor.HelperClr),
          BottomBar(BasicColor.HelperClr),
        ],
      ),
    );
  }
}

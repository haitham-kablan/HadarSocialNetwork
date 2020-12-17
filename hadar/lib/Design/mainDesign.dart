import 'dart:ui';
import 'basicTools.dart';
import 'package:flutter/material.dart';

class Sample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 100, title: 'USER'),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, index) => ListTile(
                  title: Text("Index: $index"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  String title;

  MySliverAppBar({@required this.expandedHeight, this.title});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Container( decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60)),
          ),
          child: Image.asset(
            "assets/images/color.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(

              elevation:0 ,color: Colors.transparent,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: UserCircle(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

//when using this, send the color you want to use
//see example in BackgroundDesign class
class BarDesign extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String userName;

  BarDesign(
    this.userName, {
    Key key,
  })  : preferredSize = Size(double.infinity, 150),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Text(
      //   title,
      //   style: TextStyle(color: Colors.black),
      // ),
      backgroundColor: Colors.white60,
      automaticallyImplyLeading: true,
      actions: <Widget>[
        Icon(Icons.comment, color: BasicColor.clr,),
        Icon(Icons.settings, color: BasicColor.clr,),
      ],
      elevation: 50.0,
      // bottom:PreferredSize(
      //   preferredSize: Size(double.infinity, 250),
      //   child: Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: 150,
      //     child: Container(
      //       decoration: BoxDecoration(
      //         color: BasicColor.clr,
      //         borderRadius: BorderRadius.only(
      //             bottomLeft: Radius.circular(60),
      //             bottomRight: Radius.circular(60)),
      //       ),
      //       child: Container(
      //         alignment: Alignment.topRight,
      //         margin: EdgeInsets.fromLTRB(0, 40, 10, 0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           crossAxisAlignment: CrossAxisAlignment.end,
      //           children: [
      //             Text(
      //               ' שלום $userName',
      //               // this.title,
      //               style: TextStyle(
      //                   fontSize: 20,
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

//when using this, send the color you want to use
//see example in BackgroundDesign class
//the icons aren't linked to another page yet
class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      // Scaffold(
      // backgroundColor: Colors.transparent,
      // bottomNavigationBar:
      PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
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
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                    child: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.dynamic_feed_outlined,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.add_rounded,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      // ),
    );
  }
}


class UserCircle extends StatelessWidget {
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
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}


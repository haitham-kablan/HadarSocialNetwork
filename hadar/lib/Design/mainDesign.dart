import 'dart:ui';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:hadar/feeds/adminfeedtile.dart';
import 'package:hadar/main_pages/AdminPage.dart';
import 'package:hadar/users/CurrentUser.dart';

import '../profiles/adminProfile.dart';
import '../profiles/profile.dart';
import '../feeds/viewRegisteredUsers.dart';
import 'basicTools.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';


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
        Container(
          child: Image.asset(
            "assets/images/color.jpg",
            fit: BoxFit.cover,
          ),
        ),
        // Container( alignment: Alignment.topRight, child: Text(' שלום $title') ),
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
                // child: UserCircle(),
              ),
            ),
          ),
        ),
        Navigator.canPop(context) ? Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width/30,
          child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left , color: Colors.white,size: 45,),
              onPressed: (){
                print("asdasd");
                if(Navigator.canPop(context)){
                  print("asdasdddd23333333333");
                  Navigator.pop(context);
                }else{
                  print("asdasdddd");
                  Navigator.pop(context);

                }
              },
            ),
        ) : Container(),
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
//the icons aren't linked to another page yet
class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: BasicColor.backgroundClr,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(-3, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(60, 10, 60, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(flex: 1,),
                  FlatButton(
                    child: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(CurrentUser.curr_user)));
                    },
                  ),
                  Spacer(flex: 1,),

                  FlatButton(
                    child: Icon(
                      Icons.dynamic_feed_outlined,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () async {
                      Widget curr_widget = await CurrentUser.init_user(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => curr_widget),
                      );
                    },
                  ),
                  Spacer(flex: 1,),

                ],
              ),
            ),
          ),
        ),
      // ),
    );
  }
}

class AdminBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: BasicColor.backgroundClr,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(-3, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(60, 10, 60, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(flex: 1,),
                  FlatButton(
                    child: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminProfile()
                        ),
                      );
                    },
                  ),
                  Spacer(flex: 1,),
                  FlatButton(
                    child: Icon(Icons.supervisor_account_sharp,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllUsersView()
                        ),
                      );
                    },
                  ),
                  Spacer(flex: 1,),
                  FlatButton(
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 30,
                      color: BasicColor.clr,
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminPage(CurrentUser.curr_user)

                        )
                      );
                    }
                  ),
                  Spacer(flex: 1,),
                ],
              ),
            ),
          ),
        ),
        // ),
      );
  }
}

// in  the future this will show the user picture
// gets the user name and looks for the picture in the database
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
              'assets/images/try.png',
              // width: 150,
              // height: 150,
            ),
          ),
        ],
      ),
    );
  }
}


class adminViewRequestsBar extends StatelessWidget {
  String title;
  adminViewRequestsBar(this.title);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Navigator.canPop(context) ? Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
            icon: Icon(Icons.chevron_right , color: Colors.white,size: 45,),
            onPressed: (){
              print("asdasd");
              if(Navigator.canPop(context)){
                print("asdasdddd23333333333");
                Navigator.pop(context);
              }else{
                print("asdasdddd");
                Navigator.pop(context);

              }
            },
        ),
      ) : Container(),
      automaticallyImplyLeading: false,
      expandedHeight: 80.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
          background: Image.asset(
        "assets/images/color.jpg",
        fit: BoxFit.cover,
      ),),
    );
  }
}




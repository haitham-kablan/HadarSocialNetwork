import 'package:hadar/profiles/profileItems/basicItemsForAllProfiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart' as a;
import '../Design/basicTools.dart';
import '../Design/mainDesign.dart';

class AdminProfile extends StatelessWidget {
  a.User user;
  String privilege;
  BasicLists getLists;
  bool adminIsOnProfile = false;

  AdminProfile(a.User user) {
    this.user = user;
    privilege = 'Admin';
    a.User currUser= CurrentUser.curr_user;
    if(currUser.id != user.id)
      adminIsOnProfile=true;
  }



  Widget userOrAdminAccess() {
    if (adminIsOnProfile) return SortByCatForAll(user, this,getLists.listForUserAdminView);
    return SortByCatForAll(user, this,getLists.listForAdminView);
  }

  @override
  Widget build(BuildContext context) {

    getLists = BasicLists(user, this, context);

    return Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: user.name),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MainInfo(user, privilege),
                    SizedBox(
                      height: 40,
                    ),
                    // SortByCatForAll(user, this, getLists.listForAdminView),
                    userOrAdminAccess(),
                    SizedBox(
                      height: 80,
                    ),
                    SignOut(),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}

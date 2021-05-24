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

  AdminProfile() {
    user = CurrentUser.curr_user;
    privilege = 'Admin';
    getLists = BasicLists(user, this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Profile',
      home: Scaffold(
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
                    SortByCatForAll(user, this, getLists.listForAdminView),
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
      ),
    );
  }
}

import 'package:hadar/profiles/profileItems/basicItemsForAllProfiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/User.dart' as a;
import '../Design/basicTools.dart';
import '../Design/mainDesign.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  a.User user;
  String privilege;
  bool adminIsOnProfile = false;
  BasicLists getLists;

  ProfilePage(a.User currUser) {
    user = CurrentUser.curr_user;

    if (user.privilege == Privilege.Admin) {
      adminIsOnProfile = true;
      privilege = 'Admin';
      user = currUser;
    }
    switch (user.privilege) {
      case Privilege.UserInNeed:
        privilege = 'User in need';
        break;
      case Privilege.Volunteer:
        privilege = 'Volunteer';
        break;
      case Privilege.Organization:
        privilege = 'Organization';
        break;
      default:
        privilege = 'default';
        break;
    }
  }

  Widget userOrAdminAccess() {
    if (adminIsOnProfile) return SortByCatForAll(user, this,getLists.listForUserAdminView);
    return SortByCatForAll(user, this,getLists.listForUserView);
  }

  Widget checkBottomBar() {
    if (adminIsOnProfile) return AdminBottomBar();
    return BottomBar();
  }

  Widget ifUserShowSignOut() {
    if (adminIsOnProfile) return SizedBox();
    return SignOut();
  }

  @override
  Widget build(BuildContext context) {
    getLists=BasicLists(user, this, context);

    return Scaffold(
        bottomNavigationBar: checkBottomBar(),
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
                    userOrAdminAccess(),
                    SizedBox(
                      height: 80,
                    ),
                    ifUserShowSignOut(),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}

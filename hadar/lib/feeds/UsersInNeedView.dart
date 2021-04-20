import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:provider/provider.dart';

import 'package:hadar/users/User.dart';
import '../profile.dart';
import 'feed_items/help_request_tile.dart';

class UsersInNeedView extends StatelessWidget{
  UsersInNeedView();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserInNeed>>.value(
      value: DataBaseService().getAllUsersInNeed(),
      child: AdminAllUsersView(),
    );
  }

}

class AdminAllUsersView extends StatelessWidget{
  List<UserInNeed> usersInNeed;

  @override
  Widget build(BuildContext context) {
    usersInNeed = Provider.of<List<UserInNeed>>(context);
    List<FeedTile> feedTiles = [];

    if (usersInNeed != null) {
      feedTiles = usersInNeed.map((UserInNeed user) {

        return FeedTile(tileWidget: UserItem(
          user: user, parent: this,
        ),);

      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (usersInNeed == null) ? 0 : usersInNeed.length,
        padding: const EdgeInsets.only(bottom: 70.0, top: 40),
        children: feedTiles,
      ),
    );

  }
}


class UserItem extends StatelessWidget {
  UserItem({this.user, this.parent})
      : super(key: ObjectKey(user));

  final User user;
  final AdminAllUsersView parent;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(user)
          ),
        );
      },
      isThreeLine: true,
      title: Row(children: <Widget>[
        Container(
          child: Text("שם:  " +user.name,
              style: TextStyle(color: BasicColor.clr)),
        ),
        Spacer(),
        Container(
          child: Text(user.email),
          alignment: Alignment.topLeft,
        ),
      ]),
      subtitle: Row(
        children: <Widget>[
          Container(
            child: Text("מספר טלפון:  " +user.phoneNumber),
            padding: const EdgeInsets.only(top: 8, left: 8),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/profiles/profile.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:provider/provider.dart';

import 'package:hadar/users/User.dart';

import 'feed_items/help_request_tile.dart';

class AdminsView extends StatelessWidget{
  AdminsView();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Admin>>.value(
      value: DataBaseService().getAllAdmins(),
      child: AllAdminsView(),
    );
  }

}

class AllAdminsView extends StatelessWidget{
  List<Admin> admins;

  @override
  Widget build(BuildContext context) {
    admins = Provider.of<List<Admin>>(context);
    List<FeedTile> feedTiles = [];

    if (admins != null) {
      feedTiles = admins.map((Admin user) {

        return FeedTile(tileWidget: UserItem(
          user: user, parent: this,
        ),);

      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (admins == null) ? 0 : admins.length,
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
  final AllAdminsView parent;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Row(children: <Widget>[
        Container(
          child: Text("שם:  " + user.name,
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
            child: Text("מספר טלפון:  " + user.phoneNumber),
            padding: const EdgeInsets.only(top: 8, left: 8),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:provider/provider.dart';

import 'package:hadar/users/User.dart';

import '../services/DataBaseServices.dart';
import '../users/Organization.dart';
import 'feed_items/help_request_tile.dart';

class OrganizationView extends StatelessWidget {
  OrganizationView();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Organization>>.value(
    value: DataBaseService().getAllOrganizations(),
    child: AdminOrganizationView(),
    );
  }
}

class AdminOrganizationView extends StatelessWidget {
  List<Organization> organizations;

  @override
  Widget build(BuildContext context) {
    organizations = Provider.of<List<Organization>>(context);
    List<FeedTile> feedTiles = [];

    if (organizations != null) {
      feedTiles = organizations.map((Organization user) {

        return FeedTile(tileWidget: UserItem(
          user: user, parent: this,
        ),);

      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (organizations == null) ? 0 : organizations.length,
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
  final AdminOrganizationView parent;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Row(children: <Widget>[
        Container(
          child: Text("שם עמותה:  " +user.name,
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
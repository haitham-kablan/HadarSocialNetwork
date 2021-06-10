import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:provider/provider.dart';

import 'package:hadar/users/User.dart';

import 'feed_items/help_request_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VolunteersView extends StatelessWidget{
  VolunteersView();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Volunteer>>.value(
      value: DataBaseService().getAllVolunteers(),
      child: AdminVolunteersView(),
    );
  }

}

class AdminVolunteersView extends StatelessWidget{
  List<Volunteer> volunteers;

  @override
  Widget build(BuildContext context) {
    volunteers = Provider.of<List<Volunteer>>(context);
    List<FeedTile> feedTiles = [];

    if (volunteers != null) {
      feedTiles = volunteers.map((Volunteer user) {

        return FeedTile(tileWidget: UserItem(
          user: user, parent: this,
        ),);

      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (volunteers == null) ? 0 : volunteers.length,
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
  final AdminVolunteersView parent;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Row(children: <Widget>[
        Container(
          child: Text(AppLocalizations.of(context).nameTwoDots + user.name,
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
            child: Text(AppLocalizations.of(context).telNumberTwoDots + user.phoneNumber),
            padding: const EdgeInsets.only(top: 8, left: 8),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


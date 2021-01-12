import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:provider/provider.dart';
import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';
import 'package:hadar/users/User.dart';



class UserItem extends StatelessWidget {
  UserItem({this.user, this.parent})
      : super(key: ObjectKey(user));

  final User user;
  final AllUsersView parent;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: <Widget>[
        Container(
          child: Text(user.name,
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
            child: Text(user.phoneNumber),
            padding: const EdgeInsets.only(top: 8, left: 8),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


class FeedTile extends StatefulWidget {
  final Widget userWidget;
  FeedTile({this.userWidget});

  @override
  _FeedTileState createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  _FeedTileState();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: Colors.brown[30],
        child: widget.userWidget,
      ),
    );
  }
}



class AllUsersView extends StatelessWidget {
  List<UserInNeed> usersInNeed;
  // List<User> volunteers;
  // List<User> admins;

  @override
  Widget build(BuildContext context) {
    usersInNeed = Provider.of<List<UserInNeed>>(context);
    List<FeedTile> feedTiles = List();

    if (usersInNeed != null) {
      feedTiles = usersInNeed.map((UserInNeed user) {

        return FeedTile(userWidget: UserItem(
          user: user, parent: this,
        ),);

      }).toList();
    }



    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              adminViewRequestsBar("משתמשים"),
              new SliverPadding(
                padding: new EdgeInsets.all(16.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        new Tab(
                            icon: Icon(Icons.account_circle_outlined,
                                size: 25),
                            text: " מבקשים עזרה"),
                        new Tab(
                            icon: Icon(Icons.supervisor_account_sharp, size: 25),
                            text: "מתנדבים"),
                        new Tab(
                            icon: Icon(Icons.admin_panel_settings_outlined,
                                size: 25),
                            text: "מנהלים"),
                      ],
                    ),
                  ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Center(child: ListView(
                semanticChildCount: (usersInNeed == null) ? 0 : usersInNeed.length,
                padding: const EdgeInsets.only(bottom: 70.0, top: 100),
                children: feedTiles,
              ),),
              Center(
                  child: Text(
                "1",
                style: TextStyle(fontSize: 20),
              )),
              Center(
                  child: Text(
                "3",
                style: TextStyle(fontSize: 20),
              )),
            ],
          ),
          // Center(
          //   child: Text("Sample text"),
        ),
      ),
      // ),
    );
  }
}

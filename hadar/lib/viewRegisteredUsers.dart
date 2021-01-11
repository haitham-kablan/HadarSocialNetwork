import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:provider/provider.dart';
import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';

class HelpRequestTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: Colors.brown[30],
        // child: widget.helpRequestWidget,
      ),
    );
  }
}

class AllUsersView extends StatelessWidget {
  // List<User> allUsers;

  @override
  Widget build(BuildContext context) {
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
              Center(
                  child: Text(
                "0",
                style: TextStyle(fontSize: 20),
              )),
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

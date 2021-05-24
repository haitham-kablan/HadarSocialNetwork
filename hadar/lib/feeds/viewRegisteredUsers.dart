import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Design/basicTools.dart';
import '../Design/mainDesign.dart';
import 'AdminsView.dart';
import 'UsersInNeedView.dart';
import 'VolunteersView.dart';


class AllUsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AdminBottomBar(),
      backgroundColor: BasicColor.backgroundClr,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              adminViewRequestsBar("משתמשים"),
              new SliverPadding(
                padding: new EdgeInsets.all(2.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        new Tab(
                            icon: Icon(Icons.account_circle_outlined, size: 25),
                            text: " מבקשי עזרה"),
                        new Tab(
                            icon:
                            Icon(Icons.supervisor_account_sharp, size: 25),
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
                child: UsersInNeedView(),
              ),
              Center(
                child: VolunteersView(),
              ),
              Center(
                child: AdminsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

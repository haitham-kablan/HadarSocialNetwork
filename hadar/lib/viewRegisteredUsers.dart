
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

class AllUsersView extends StatelessWidget{
  List<User> allUsers;

  @override
  Widget build(BuildContext context) {
    allUsers = Provider.of<List<User>>(context);
    List<HelpRequestTile> feedTiles = List();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users In need',
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: 'Users in need'),
              pinned: true,
            ),

            SliverFillRemaining(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  semanticChildCount: (allUsers == null) ? 0 : allUsers.length,
                  padding: const EdgeInsets.only(bottom: 70.0, top: 100),
                  // children: feedTiles,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

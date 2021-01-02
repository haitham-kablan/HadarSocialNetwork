

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:provider/provider.dart';


class showAllRequests extends StatefulWidget {
  @override
  _showAllRequestsState createState() => _showAllRequestsState();
}

class _showAllRequestsState extends State<showAllRequests> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HelpRequest>>.value(
      value: DataBaseService().getAllRequests(),
      child: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: MySliverAppBar(expandedHeight: 150, title: CurrentUser.curr_user.name),
                pinned: true,
              ),
              SliverFillRemaining( child: AdminFeed(),
              ),
            ]
        ),
      ),
    );
  }
}


class AdminFeed extends StatefulWidget {
  @override
  _AdminFeed createState() => _AdminFeed();
}

class _AdminFeed extends State<HelperFeed> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<HelpRequest>>(context);



    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Builder(
        builder: (BuildContext context) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 70.0, top: 100),
            itemCount: (requests == null) ? 0 : requests.length,
            itemBuilder: (context,index){
              return HelpRequestTile(helpRequestWidget: VolunteerFeedTile(requests[index]));
            },
          );
        },
      ),
    );

  }

}
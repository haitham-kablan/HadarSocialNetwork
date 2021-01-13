import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';


class HelperFeed extends StatefulWidget {
  @override
  _HelperFeedState createState() => _HelperFeedState();
}

class _HelperFeedState extends State<HelperFeed> {
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
                return FeedTile(tileWidget: VolunteerFeedTile(requests[index]));
              },
            );
          },
        ),
      );

  }

}


class VolunteerFeed extends StatelessWidget {
  Volunteer curr_user;
  VolunteerFeed(this.curr_user);
  @override
  Widget build(BuildContext context) {
    List<HelpRequestType> list1 = List<HelpRequestType>();
    list1.add(HelpRequestType('food'));
    list1.add(HelpRequestType('money'));

    return StreamProvider<List<HelpRequest>>.value(
      value: DataBaseService().getAll_waiting_Requests_for_volunteer(curr_user.id),
      child: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: CurrentUser.curr_user.name),
              pinned: true,
            ),
            SliverFillRemaining( child: HelperFeed(),
            ),
        ]),
        // body: HelperFeed(),
      ),
    );
  }
}



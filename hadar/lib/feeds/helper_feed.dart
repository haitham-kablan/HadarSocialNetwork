import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/feed_items/VolFeedDropDown.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import 'feed_items/category_scrol.dart';

class volunteer_feed_pafe_state {
  static _VolunteerFeedStatefullState state = null;
}

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
            padding: const EdgeInsets.only(bottom: 70.0, top: 20),
            itemCount: (requests == null) ? 0 : requests.length,
            itemBuilder: (context, index) {
              return FeedTile(tileWidget: VolunteerFeedTile(requests[index]));
            },
          );
        },
      ),
    );
  }
}

class VolunteerFeedStatefull extends StatefulWidget {
  Volunteer curr_user;
  String title = '';

  VolunteerFeedStatefull(this.curr_user, this.categories, this.title);

  List<MyListView> categories;

  @override
  _VolunteerFeedStatefullState createState() =>
      _VolunteerFeedStatefullState(curr_user, categories, title);
}

class _VolunteerFeedStatefullState extends State<VolunteerFeedStatefull> {
  Volunteer curr_user;
  String title = '';

  _VolunteerFeedStatefullState(this.curr_user, this.categories, this.title);

  List<MyListView> categories;

  @override
  Widget build(BuildContext context) {
    volunteer_feed_pafe_state.state = this;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await DataBaseService().updateVolCategories([HelpRequestType("אוכל")], curr_user as Volunteer);
      //   },
      //
      // ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: BasicColor.backgroundClr,
      body: CustomScrollView(slivers: [
        adminViewRequestsBar(title),
        SliverFillRemaining(
          child: Container(
            // margin: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Expanded(
                    child: StatefulCategoriesList(
                        categories,
                        DataBaseService().get_requests_for_category(
                            HelpRequestType(categories[0].Help_request_type),
                            curr_user.id),
                        categories[0].Help_request_type)),
                //Expanded(child: HelperFeed()),
              ],
            ),
          ),
        ),
      ]),
      // body: HelperFeed(),
    );
  }
}

class VolunteerFeed extends StatelessWidget {
  Volunteer curr_user;
  String title = '';

  VolunteerFeed(this.curr_user, this.categoers, this.title);

  List<MyListView> categoers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      backgroundColor: BasicColor.backgroundClr,
      body: CustomScrollView(slivers: [
        adminViewRequestsBar(title),
        SliverFillRemaining(
          child: Container(
            // margin: EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Expanded(
                    child: StatefulCategoriesList(
                        categoers,
                        DataBaseService().get_requests_for_category(
                            HelpRequestType(categoers[0].Help_request_type),
                            curr_user.id),
                        categoers[0].Help_request_type)),
                //Expanded(child: HelperFeed()),
              ],
            ),
          ),
        ),
      ]),
      // body: HelperFeed(),
    );
  }
}

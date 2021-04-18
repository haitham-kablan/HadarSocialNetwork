import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Organization.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import 'feed_items/category_scrol.dart';

class organization_feed_pafe_state {
  static _OrganizationFeedStatefulState state = null;
}

class OrganizationFeed extends StatefulWidget {
  @override
  _OrganizationFeedState createState() => _OrganizationFeedState();
}

class _OrganizationFeedState extends State<OrganizationFeed> {
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

class OrganizationFeedStateful extends StatefulWidget {
  Organization curr_user;
  String title = '';

  OrganizationFeedStateful(this.curr_user, this.categories, this.title);

  List<MyListView> categories;

  @override
  _OrganizationFeedStatefulState createState() =>
      _OrganizationFeedStatefulState(curr_user, categories, title);
}

class _OrganizationFeedStatefulState extends State<OrganizationFeedStateful> {
  Organization curr_user;
  String title = '';

  _OrganizationFeedStatefulState(this.curr_user, this.categories, this.title);

  List<MyListView> categories;

  @override
  Widget build(BuildContext context) {
    organization_feed_pafe_state.state = this;
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
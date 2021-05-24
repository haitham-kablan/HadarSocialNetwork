import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/OrganizationFeed.dart';
import 'package:hadar/feeds/feed_items/category_scrol.dart';
import 'package:hadar/users/Organization.dart';
/*
class OrganizationPage extends StatelessWidget {
  final Organization curr_user;
  List<MyListView> categories;

  OrganizationPage(this.curr_user, this.categories);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: Center(
          child: Text(
            "You have no available services!",
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 22.0,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      );
    }
    return OrganizationFeedStateful(
        curr_user, categories, categories[0].Help_request_type);
  }
}
*/
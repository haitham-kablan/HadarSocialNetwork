import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/adminProfile.dart';

import 'Design/mainDesign.dart';


class userInquiryView extends StatelessWidget {
  userInquiryView(AdminProfile adminProfile);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
              MySliverAppBar(expandedHeight: 150, title: 'פנייה'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column( children:[
                  SizedBox(
                    height: 100,
                  ),

                  SizedBox(
                    height: 40,
                  ),

                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



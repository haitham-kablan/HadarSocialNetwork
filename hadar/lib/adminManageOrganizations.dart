import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/OrganizationFeed.dart';

class ManageOrganizations extends StatelessWidget {
  const ManageOrganizations({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: BasicColor.backgroundClr,
        bottomNavigationBar: BottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 150, title: 'עמותות'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'ניהול העמותות',
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(height: 300, child: OrganizationsInfoList()),
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

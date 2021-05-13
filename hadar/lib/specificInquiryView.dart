import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadar/utils/UsersInquiry.dart';
import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';

class specificInquiryView extends StatelessWidget {
  UserInquiry inquiry;

  specificInquiryView(UserInquiry userInquiry) {
    inquiry = userInquiry;
  }

  Widget getData(String title, String data) {
    return Column(
      children: [
            Container(
              alignment: Alignment.topRight,
              child:
                Text(
                  data + "  :" + title,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                     ),
                ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: 'פנייה'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    getData('שם הפונה', inquiry.name),
                    getData('תעודת זהות', inquiry.id),
                    getData('מספר טלפון', inquiry.phoneNumber),
                    getData('סיבת הפנייה', inquiry.reasonForInquiry),
                    getData('תוכן הפנייה', inquiry.description),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadar/utils/UsersInquiry.dart';
import '../Design/basicTools.dart';
import '../Design/mainDesign.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  title + ":  " + data,
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

    return  Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: AppLocalizations.of(context).inquiry),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    getData(AppLocalizations.of(context).inquirer, inquiry.name),
                    getData(AppLocalizations.of(context).id, inquiry.id),
                    getData(AppLocalizations.of(context).telNumber, inquiry.phoneNumber),
                    getData(AppLocalizations.of(context).inquiryReason, inquiry.reasonForInquiry),
                    getData(AppLocalizations.of(context).inquiryInfo, inquiry.description),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}

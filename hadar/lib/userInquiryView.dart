import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/specificInquiryView.dart';
import 'package:hadar/utils/UsersInquiry.dart';
import 'package:provider/provider.dart';

import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';
import 'feeds/feed_items/help_request_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';





class InquiriesView extends StatelessWidget{
  InquiriesView();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserInquiry>>.value(
      value: DataBaseService().getAll_inquires(),
      child: AllInquieriesView(),
    );
  }

}

class AllInquieriesView extends StatelessWidget{
  List<UserInquiry> usersInquiries;

  @override
  Widget build(BuildContext context) {
    usersInquiries = Provider.of<List<UserInquiry>>(context);
    List<FeedTile> feedTiles = [];

    if (usersInquiries != null) {
      feedTiles = usersInquiries.map((UserInquiry inquiry) {

        return FeedTile(tileWidget: InquiryItem(
          inquiry: inquiry, parent: this,
        ),);

      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (usersInquiries == null) ? 0 : usersInquiries.length,
        padding: const EdgeInsets.only(bottom: 70.0, top: 70),
        children: feedTiles,
      ),
    );

  }
}


class InquiryItem extends StatelessWidget {
  InquiryItem({this.inquiry, this.parent})
      : super(key: ObjectKey(inquiry));

  final UserInquiry inquiry;
  final AllInquieriesView parent;



  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => specificInquiryView(inquiry)
          ),
        );
      },
      isThreeLine: true,
      title: Row(children: <Widget>[
        Container(
          child: Text(AppLocalizations.of(context).inquiryReasonTwoDots + inquiry.reasonForInquiry,
              style: TextStyle(color: BasicColor.clr)),
        ),
        Spacer(),
      ]),
      subtitle: Row(
        children: <Widget>[
          Container(
            child: Text(AppLocalizations.of(context).nameTwoDots +inquiry.name),
            padding: const EdgeInsets.only(top: 8, left: 8),
          ),
          Spacer(),
          Container(
            child: Text(AppLocalizations.of(context).telNumberTwoDots +inquiry.phoneNumber),
            padding: const EdgeInsets.only(top: 8, left: 8),
          ),
          Spacer(),
        ],
      ),
    );
  }
}






class userInquiryView extends StatelessWidget {
  userInquiryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
              MySliverAppBar(expandedHeight: 150, title: AppLocalizations.of(context).usersInquiries),
              pinned: true,
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  Expanded(child: InquiriesView()),
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 80,
                    padding: EdgeInsets.all(20.0),
                    child: TextButton(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context).back,
                            style: TextStyle(
                                fontSize: 17.0,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(left: 10.0),
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(
                            context,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}



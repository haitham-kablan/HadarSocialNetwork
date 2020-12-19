import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:provider/provider.dart';

import 'dart:developer';

import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';
import 'UserInNeedRequestView.dart';

import 'feeds/feed_items/help_request_tile.dart';


bool debug = true;

class UserInNeedHelpRequestsFeed extends StatefulWidget{


  UserInNeedHelpRequestsFeed({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => HelpRequestFeedState();

}


class HelpRequestFeedState extends State<UserInNeedHelpRequestsFeed>{
  List<HelpRequest> feed;

  HelpRequestFeedState();

  // adding or removing items from the _feed should go through this function in
  // order for the widget state to be updated
  // if addedRequest is true, then the change that will be done is adding the
  // given helpRequest to the feed.
  // Otherwise, the given helpRequest will be removed from the feed
  void handleFeedChange(HelpRequest helpRequest, bool addedRequest) {
    setState(() {
      if (addedRequest) {
        feed.add(helpRequest);
        DataBaseService().addHelpRequestToDataBaseForUserInNeed(helpRequest);
        if(debug)
          log("feed size = " + feed.length.toString());
      }
      else
        feed.remove(helpRequest);
      //todo: remove from database

      //feed.removeWhere((element) => element.category.description == "money");
    });
  }

  void showHelpRequestStatus(HelpRequest helpRequest) {
    showModalBottomSheet(
        context: context,
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30) ,topRight: Radius.circular(30))
        ),*/
        builder: (context) {
          return HelpRequestStatusWidget(helpRequest, this);
        });
  }

  @override
  Widget build(BuildContext context) {

    feed = Provider.of<List<HelpRequest>>(context);
    List<HelpRequestTile> feedTiles = List();

    if(feed != null) {
      feedTiles = feed.map((HelpRequest helpRequest) {
        return HelpRequestTile(helpRequestWidget: HelpRequestItem(
          helpRequest: helpRequest, parent: this,
        ),);
      }).toList();
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User In-need Feed',
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: 'USER'),
              pinned: true,
            ),

            SliverFillRemaining(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  semanticChildCount: (feed == null) ? 0 : feed.length,
                  padding: const EdgeInsets.only(bottom: 70.0, top: 100),
                  children: feedTiles,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(bottom: 20.0, right: 5),
          child: FloatingActionButton.extended(
            onPressed: () async {
              List<HelpRequestType> types = await DataBaseService().helpRequestAsAlist();
              types.add(HelpRequestType('אחר..'));
              //we must add אחר so it always appears on the last of the list
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestWindow(this,types)),
              );
            },
            label: HebrewText("בקש עזרה"),
            icon: Icon(Icons.add),
            backgroundColor: BasicColor.clr,
            elevation: 10,
          ),
        ),
      ),
    );

  }
}


class HelpRequestItem extends StatelessWidget {
  HelpRequestItem({this.helpRequest, this.parent})
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;
  final HelpRequestFeedState parent;

  @override
  Widget build(BuildContext context) {
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();
    return ListTile(
      onTap: () => parent.showHelpRequestStatus(helpRequest),
      isThreeLine: true,
      title: Row(
          children: <Widget> [
            Container(
              child:Text(helpRequest.category.description, style:TextStyle(color: BasicColor.clr)) ,
              //alignment: Alignment.topLeft,
            ),
            Spacer(),
            Container(
              child:Text(dateFormat.format(helpRequest.date)),
              alignment: Alignment.topLeft,
            ),
          ]
      ),
      subtitle: Container(
        child: HebrewText(helpRequest.description),
        //alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 8, left: 8),
      ),

    );
  }
}


class HelpRequestStatusWidget extends StatelessWidget {
  HelpRequestStatusWidget(this.helpRequest, this.feedWidgetObject)
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;
  final HelpRequestFeedState feedWidgetObject;

  @override
  Widget build(BuildContext context) {
    return Container(
      //this color is to make the corners look transparent to the main screen: Color(0xFF696969)
        color: Color(0xFF696969),
        height: MediaQuery.of(context).size.height /2,
        child: Container(
          decoration:  BoxDecoration(
            color: BasicColor.backgroundClr,
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(20),
              topLeft: const Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child:Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  //width: MediaQuery.of(context).size.width,
                  child:Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      helpRequest.date.toString().substring(0, 16),
                      style: TextStyle(
                        fontSize: 14,
                        color: BasicColor.clr,
                        fontFamily: "Arial",
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      helpRequest.category.description + ":",
                      style: TextStyle(
                          fontSize: 30,
                          color:BasicColor.clr,
                          fontFamily: "Arial"
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      helpRequest.description,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Arial"
                      ),
                      maxLines: 10,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                Expanded(//height: 100,
  //              padding: const EdgeInsets.only(left: 20),

                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      onPressed: (){
                        feedWidgetObject.handleFeedChange(HelpRequest.copy(helpRequest), true);
                        if (Navigator.canPop(context)) {
                          Navigator.pop(
                            context,
                          );
                        }
                        else{
                          log("error: couldn't pop the ModalBottomSheet context from the navigator!");
                        }
                        //print("height: " + (MediaQuery.of(context).size.height /2).toString());
                      },
                      child: Text('renew request'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

}


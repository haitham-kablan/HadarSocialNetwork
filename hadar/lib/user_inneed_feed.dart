
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dart:developer';

import 'Design/basicTools.dart';
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
//      theme: ThemeData(
//       // primarySwatch: Colors.teal,
//      ),
      home: Scaffold(
        backgroundColor: BasicColor.BackgroundClr,
        appBar: AppBar(
          backgroundColor: BasicColor.userInNeedClr,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20,),
              HebrewText("הבקשות שלי"),
            ],
          )
        ),
        body: ListView(
                semanticChildCount: (feed == null) ? 0 : feed.length,
                padding: const EdgeInsets.only(bottom: 70.0),
                children: feedTiles,
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            List<HelpRequestType> types = await DataBaseService().helpRequestAsAlist();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestWindow(this,types)),
            );
          },
          label: HebrewText("בקש עזרה"),
          icon: Icon(Icons.add),
          backgroundColor: BasicColor.userInNeedClr,
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
    final DateFormat dateFormat = DateFormat.yMd().add_Hm();
    return ListTile(
      onTap: () => parent.showHelpRequestStatus(helpRequest),
      isThreeLine: true,
      title: Row(
          children: <Widget> [
            Container(
              child:HebrewText(helpRequest.category.description) ,
              alignment: Alignment.topLeft,
            ),
            Spacer(),
            Container(
              child:Text(dateFormat.format(helpRequest.date)),
              alignment: Alignment.topRight,
            ),
          ]
      ),
      subtitle: Container(
        child: HebrewText(helpRequest.description),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 8),
      ),

    );
  }
}

class HelpRequestItemTile extends StatelessWidget {

  HelpRequestItemTile({this.helpRequest})
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
      //height: 100,
      //color: Colors.transparent,
      child: Column(
        children: [
          Container(
            child: Text("request: " + helpRequest.category.description + ":"),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 8),
          ),
          //SizedBox(height: 8,),
          Container(
            child: Text(helpRequest.description),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 8, left: 10),
          ),
          Container(
            //we trim the date object to include only the date, hours and minutes
            child: Text(helpRequest.date.toString().substring(0, 16)),
            alignment: Alignment.bottomRight,
          ),

        ],
      )
    );
  }
}

class HelpRequestStatus extends StatelessWidget{
  HelpRequestStatus(this.helpRequest)
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: helpRequest.category.description,
      home: Container(
        padding: const EdgeInsets.only(top: 40, bottom: 200),
        child: Column(
          children: [

            /*Container(
              child:*/ Scaffold(
                appBar: AppBar(
                  title: Row(
                    children:[
                      Container(
                        width: 100,
                        child: BackButton(
                          color: Colors.deepOrange,
                          onPressed: () {
                            if(Navigator.canPop(context)) {
                              Navigator.pop(
                                context,
                              );
                            }
                          },
                        ),
                      )

                    ],
                  )
                ),

                //a BackButton requires a material widget parent..
                body: Container(
                  height: 500,
                  child: Text(
                    "Here goes the status of this help request",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[800],
                        fontFamily: "Arial"
                    ),
                  ),
                ),
              )
           //),

          ],
        ),
        color: Colors.white,
      )
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
              color: BasicColor.BackgroundClr,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20),
                topLeft: const Radius.circular(20),
              ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                //width: MediaQuery.of(context).size.width,
                child:Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    helpRequest.date.toString().substring(0, 16),
                    style: TextStyle(
                      fontSize: 14,
                      color: BasicColor.userInNeedClr,
                      fontFamily: "Arial",
                    ),
                  ),
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    helpRequest.category.description + ":",
                    style: TextStyle(
                      fontSize: 30,
                      color:BasicColor.userInNeedClr,
                      fontFamily: "Arial"
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(right: 20, bottom: 20, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
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
        )
      );
  }

}

/*
//show/hide, not used yet..
//when clicking on a post a slide sheet appears with the options of renew, and
//track the request
//will be used after the feed is implemented
class HelpRequestStatusWidget extends StatefulWidget {
  HelpRequestStatusWidget({Key key, this.helpRequest}) : super(key: key);

  final HelpRequest helpRequest;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _HelpRequestStatusWidget extends State<HelpRequestStatusWidget> {
  /*void slideSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return HelpRequestStatusWidget(widget.helpRequest);
        });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: slideSheet,
          child: Text('Click'),
        ),
      ),
    );
  }
}
*/


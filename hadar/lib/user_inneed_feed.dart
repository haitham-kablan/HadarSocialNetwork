
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'dart:developer';
bool debug = true;

class UserInNeedHelpRequestsFeed extends StatefulWidget{
  UserInNeedHelpRequestsFeed({Key key, this.helpRequests}): super(key: key);

  final List<HelpRequest> helpRequests;

  @override
  State<StatefulWidget> createState() => HelpRequestFeedState(helpRequests.toSet());

}

class HelpRequestFeedState extends State<UserInNeedHelpRequestsFeed>{
  Set<HelpRequest> feed;

  HelpRequestFeedState(this.feed);

  // adding or removing items from the _feed should go through this function in
  // order for the widget state to be updated
  // if addedRequest is true, then the change that will be done is adding the
  // given helpRequest to the feed.
  // Otherwise, the given helpRequest will be removed from the feed
  void _handleFeedChange(HelpRequest helpRequest, bool addedRequest) {
    setState(() {
      if (addedRequest) {
        feed.add(helpRequest);
        if(debug)
          log("feed size = " + feed.length.toString());
      }
      else
        feed.remove(helpRequest);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User In-need Feed',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                RaisedButton(
                  child: Text("Add item"),
                  onPressed: (){_handleFeedChange(HelpRequest.fake(), true);},

                ),
                SizedBox(width: 20,),
                Center(
                  child: Text("My Feed"),
                ),
              ],
            )
          ),
          body: ListView(
                  padding: const EdgeInsets.all(8),
                  children: feed.map((HelpRequest helpRequest) {
                    return HelpRequestItem(
                      helpRequest: helpRequest,
                    );
                  }).toList(),
                  ),

      ),
    );

  }
}


class HelpRequestItem extends StatelessWidget {
  HelpRequestItem({this.helpRequest})
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpRequestStatus(helpRequest)),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(helpRequest.sender[0]),
          ),
          title:  HelpRequestItemTile(helpRequest: helpRequest,),
          tileColor: Colors.blueGrey[200],
          selectedTileColor: Colors.brown,
          //contentPadding: const EdgeInsets.only(bottom: 5),

        ),
        SizedBox(height: 5,),
      ]
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
      height: 100,
      child: Column(
        children: [
          Container(
            child: Text(helpRequest.sender + " request:\n" + helpRequest.description),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 8),
          ),
          //SizedBox(height: 8,),
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

            Container(
              child: Scaffold(
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
            ),

          ],
        ),
        color: Colors.white,
      )
    );
  }
}

class HelpRequestStatusWidget extends StatelessWidget {
  HelpRequestStatusWidget(this.helpRequest)
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;

  @override
  Widget build(BuildContext context) {

  }
}

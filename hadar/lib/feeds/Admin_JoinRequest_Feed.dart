import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/utils/VerificationRequest.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:url_launcher/url_launcher.dart';

import 'feed_items/help_request_tile.dart';

class AdminJoinRequestsFeed extends StatefulWidget{

  final Admin admin;
  AdminJoinRequestsFeed({Key key, this.admin}): super(key: key);

  @override
  State<StatefulWidget> createState() => AdminJoinRequestsFeedState();

}


class AdminJoinRequestsFeedState extends State<AdminJoinRequestsFeed>{

  List<VerificationRequest> feed;

  AdminJoinRequestsFeedState(){
    //**test** todo: remove this
    feed = List();
    UnregisteredUser testUser1 = UnregisteredUser("מורסי", "0526419285", "morsi@gmail.com", "789456");
    UnregisteredUser testUser2 = UnregisteredUser("סיראג", "0523636921", "siraj@gmail.com", "456123");
    feed.add(VerificationRequest(testUser1, "Volunteer", DateTime.now()));
    feed.add(VerificationRequest(testUser2, "Admin", DateTime.now()));
  }

  // adding or removing items from the _feed should go through this function in
  // order for the widget state to be updated
  // if addedRequest is true, then the change that will be done is adding the
  // given helpRequest to the feed.
  // Otherwise, the given helpRequest will be removed from the feed
  void handleFeedChange(VerificationRequest joinRequest, bool addedRequest) {
    setState(() {
      if (addedRequest) {
        feed.add(joinRequest);
        //todo: add verification request to database

      }
      else {
        feed.remove(joinRequest);
        //feed.removeWhere((element) => element.sender.id == joinRequest.sender.id);
        log("feed size = " + feed.length.toString());
        //todo: remove from database
      }

      //feed.removeWhere((element) => element.category.description == "money");
    });
  }

  void showJoinRequestStatus(VerificationRequest joinRequest) {
    showModalBottomSheet(
        context: context,
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30) ,topRight: Radius.circular(30))
        ),*/
        builder: (context) {
          return JoinRequestStatusWidget(joinRequest, this);
        });
  }

  @override
  Widget build(BuildContext context) {

    //feed = Provider.of<List<VerificationRequest>>(context);
    List<FeedTile> feedTiles = List();

    if(feed != null) {
      feedTiles = feed.map((VerificationRequest joinRequest) {
        return FeedTile(helpRequestWidget: JoinRequestItem(
          joinRequest: joinRequest, parent: this,
        ),);
      }).toList();
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin JoinRequests Feed',
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: widget.admin.name),
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

      ),
    );

  }
}

class JoinRequestItem extends StatelessWidget {
  JoinRequestItem({this.joinRequest, this.parent})
      : super(key: ObjectKey(joinRequest));

  final VerificationRequest joinRequest;
  final AdminJoinRequestsFeedState parent;

  @override
  Widget build(BuildContext context) {
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();
    return ListTile(
      onTap: () => parent.showJoinRequestStatus(joinRequest),
      isThreeLine: true,
      title: Row(
          children: <Widget> [
            Container(
              child:(){
                String userType = "מבקש עזרה";
                if(joinRequest.type == "Volunteer")
                  userType = "מתנדב";
                else if(joinRequest.type == "Admin")
                  userType = "מנהל";
                return Text(joinRequest.sender.name + " רוצה להירשם כ" + userType , style:TextStyle(color: BasicColor.clr));
              }() ,
              //alignment: Alignment.topLeft,
            ),
            Spacer(),
            Container(
              child:Text(dateFormat.format(joinRequest.date)),
              alignment: Alignment.topLeft,
            ),
          ]
      ),
      subtitle: Container(
          child:
                Row(children: <Widget>[
                  Spacer(),
                  Spacer(),
                  CallWidget(joinRequest.sender.phoneNumber),
                ]),

      ),

    );
  }
}

class CallWidget extends StatelessWidget {
  final String phoneNumber;

  CallWidget(this.phoneNumber);

  _launchCaller() async{
    var url = "tel:" + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.call,
        size: 20.0,
        color: BasicColor.clr,
      ),
      onPressed: _launchCaller,
    );
    return GestureDetector(
      onTap: () {
        _launchCaller();
      },
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(
            Icons.call,
            size: 20.0,
            color: BasicColor.clr,
          )),
    );
  }
}


class JoinRequestStatusWidget extends StatelessWidget {
  JoinRequestStatusWidget(this.joinRequest, this.feedWidgetObject)
      : super(key: ObjectKey(joinRequest));

  final VerificationRequest joinRequest;
  final AdminJoinRequestsFeedState feedWidgetObject;

  @override
  Widget build(BuildContext context) {
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();
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
                    dateFormat.format(joinRequest.date),
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
                  child: (){
                    String userType = "מבקש עזרה";
                    if(joinRequest.type == "Volunteer")
                      userType = "מתנדב";
                    else if(joinRequest.type == "Admin")
                      userType = "מנהל";
                    return Text(joinRequest.sender.name + " רוצה להירשם כ" + userType ,
                      style: TextStyle(
                        fontSize: 25,
                        color:BasicColor.clr,
                        fontFamily: "Arial"
                    ),);
                  }()
                ),
              ),

              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "שם: " + joinRequest.sender.name,
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
                  child:Row(
                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          UnregisteredUser user = joinRequest.sender;
                          /*await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: user.email,
                              password: "123456"
                          );*/

                          /*
                            todo: here we don't know what the password is, therefore
                            we should keep the user registration at the sign up screen.
                            here, we should only update a flag which implies that the
                            user has been authorized or the request is still pending,
                            or remove the request if rejected..

                          */

                          feedWidgetObject.handleFeedChange(joinRequest, false);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(
                              context,
                            );
                          }
                          else{
                            log("error: couldn't pop the ModalBottomSheet context from the navigator!");
                          }

                        },
                        child: Text('אשר בקשה'),
                      ),
                      Spacer(),
                      RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          UnregisteredUser user = joinRequest.sender;
                          //todo: remove join request and the user from database
                          feedWidgetObject.handleFeedChange(joinRequest, false);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(
                              context,
                            );
                          }
                          else{
                            log("error: couldn't pop the ModalBottomSheet context from the navigator!");
                          }

                        },
                        child: Text('דחה בקשה'),
                      ),
                    ],
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


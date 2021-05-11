import 'package:flutter/cupertino.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/getters/getUserName.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../HelpRequestAdminDialouge.dart';

class AdminVerifiedHelpRequestsFeed extends StatelessWidget {
  final Admin curr_user;
  final Status status;
  AdminVerifiedHelpRequestsFeed(this.curr_user,this.status);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HelpRequest>>.value(
      value: status == Status.UNVERFIED ?DataBaseService().getAll_unverfied_requests_Requests() : DataBaseService().getAll_approved_Requests(),
      child:_AdminVerifiedHelpRequestsFeed(),
    );
  }
}



class _AdminVerifiedHelpRequestsFeed extends StatefulWidget {
  @override
  _AdminVerifiedHelpRequestsFeedState createState() => _AdminVerifiedHelpRequestsFeedState();
}

class _AdminVerifiedHelpRequestsFeedState extends State<_AdminVerifiedHelpRequestsFeed> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<HelpRequest>>(context);

    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Builder(
        builder: (BuildContext context) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 70.0, top: 10),
            itemCount: (requests == null) ? 0 : requests.length,
            itemBuilder: (context,index){
              return FeedTile(tileWidget: AdminHelpRequestFeedTile(requests[index]));
            },
          );
        },
      ),
    );

  }
}



class AdminHelpRequestFeedTile extends StatefulWidget {
  final HelpRequest helpRequest;

  AdminHelpRequestFeedTile(this.helpRequest);
  @override
  _AdminHelpRequestFeedTileState createState() => _AdminHelpRequestFeedTileState();
}


class _AdminHelpRequestFeedTileState extends State<AdminHelpRequestFeedTile> {

  @override
  Widget build(BuildContext context) {
    final DateTime now = widget.helpRequest.date;
    final Intl.DateFormat formatter = Intl.DateFormat.yMd().add_Hm();
    Color color =  Colors.white ;
    return ListTile(
      tileColor: color,
      // onTap: () => print("List tile pressed!"),//showHelpRequestStatus(helpRequest),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return AdminHelpRequestFeedTileStatus(context, widget.helpRequest);
            });
      },
      isThreeLine: true,
      title: Row(children: <Widget>[
        Container(
          // child: Text(widget.helpRequest.category.description),
          child: GetUserName(widget.helpRequest.sender_id, DataBaseService().userInNeedCollection),
          alignment: Alignment.topRight,
        ),
        Spacer(),
        Container(
          child: HebrewText(  formatter.format(now) ),
          alignment: Alignment.topLeft,
        ),
      ]),
      subtitle: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Text(widget.helpRequest.category.description),
                  //Spacer(),
                  //Spacer(),
                  //CallWidget(widget.helpRequest),
                  //ThreeDotsWidget(widget.helpRequest)
                ]
                ),
                HebrewText(widget.helpRequest.description),
              ]
          )
      ),
    );
  }
}

class AdminHelpRequestFeedTileStatus extends StatelessWidget {
  AdminHelpRequestFeedTileStatus(context,this.helpRequest);

  final HelpRequest helpRequest;


  @override
  Widget build(BuildContext context) {
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            //this color is to make the corners look transparent to the main screen: Color(0xFF696969)
            color: Color(0xFF696969),
            //height: MediaQuery.of(context).size.height /2,
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
                          dateFormat.format(helpRequest.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: BasicColor.clr,
                            fontFamily: "Arial",
                          ),
                        ),
                      ),
                    ),

                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 2.0,vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("מבקש העזרה",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600
                                    ),),
                                ],
                              ),
                            ),
                            Expanded(
                              child:
                              Column(
                                children: [
                                  Text("המתנדב",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600
                                    ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 2.0,vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  GetHelpRequestTileUserInfo(helpRequest.sender_id,DataBaseService().userInNeedCollection,helpRequest),
                                  CallWidget(helpRequest, true),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  GetHelpRequestTileUserInfo(helpRequest.handler_id,DataBaseService().helpersCollection,null),
                                  CallWidget(helpRequest, false),
                                ],
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text('קטגוריה: ' , style: TextStyle(
                              fontSize: 15,
                              color: BasicColor.clr,fontWeight: FontWeight.bold
                          ),),
                        ),
                        Container(
                          child: Text(helpRequest.category.description ,style: TextStyle(fontSize: 15),textDirection: TextDirection.rtl, ),
                        ),
                      ],
                    ),

                    Container(
                      alignment: Alignment.topRight,
                      child: Text('תיאור הבקשה: ' ,
                        style: TextStyle(fontSize: 15 , color: BasicColor.clr ,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topRight,
                        child: Text(helpRequest.description, style: TextStyle(fontSize: 15),textDirection: TextDirection.rtl,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class CallWidget extends StatelessWidget {
  final HelpRequest helpRequest;
  final bool isUserInNeed;

  CallWidget(this.helpRequest, this.isUserInNeed);

  _launchCaller() async {
    String number;
    if(isUserInNeed) {
      UserInNeed usr = await (DataBaseService().getUserById(
          helpRequest.sender_id, Privilege.UserInNeed)) as UserInNeed;
      number = usr.phoneNumber;
    }
    else{
      Volunteer usr = await (DataBaseService().getUserById(
          helpRequest.handler_id, Privilege.Volunteer)) as Volunteer;
      number = usr.phoneNumber;
    }
    var url = "tel:" + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchCaller();
      },
      onLongPress: () => print("Long Press: Call"),
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


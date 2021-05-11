import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/VerificationRequest.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:url_launcher/url_launcher.dart';

import 'adminfeedtile.dart';
import 'feed_items/help_request_tile.dart';

class AdminJoinRequestsFeed extends StatelessWidget{
  final Admin admin;
  AdminJoinRequestsFeed(this.admin);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<VerificationRequest>>.value(
      value: DataBaseService().getVerificationRequests(),
      child: _AdminJoinRequestsFeed(admin: admin,),
    );
  }

}

class _AdminJoinRequestsFeed extends StatefulWidget{

  final Admin admin;
  _AdminJoinRequestsFeed({Key key, this.admin}): super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminJoinRequestsFeedState();

}


class _AdminJoinRequestsFeedState extends State<_AdminJoinRequestsFeed>{

  List<VerificationRequest> feed;

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

  void handleAcceptVerificationRequest(VerificationRequest joinRequest, List<HelpRequestType> categories){
    setState(() {
      feed.remove(joinRequest);
      DataBaseService().AcceptVerificationRequest(joinRequest, categories);
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

    feed = Provider.of<List<VerificationRequest>>(context);
    //final requests = Provider.of<List<HelpRequest>>(context);
    List<FeedTile> feedTiles = [];

    if(feed != null) {
      feedTiles = feed.map((VerificationRequest joinRequest) {
        return FeedTile(tileWidget: JoinRequestItem(
          joinRequest: joinRequest, parent: this,
        ),);
      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (feed == null) ? 0 : feed.length,
        padding: const EdgeInsets.only(bottom: 70.0, top: 10),
        children: feedTiles,
      ),
    );

  }
}

class JoinRequestItem extends StatelessWidget {
  JoinRequestItem({this.joinRequest, this.parent})
      : super(key: ObjectKey(joinRequest));

  final VerificationRequest joinRequest;
  final _AdminJoinRequestsFeedState parent;

  @override
  Widget build(BuildContext context) {
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();
    return ListTile(
      onTap: () => parent.showJoinRequestStatus(joinRequest),
      isThreeLine: true,
      title: Column(
        children: [

          Row(
              children: <Widget> [
                Container(
                  child: Text(joinRequest.sender.name),
                  alignment: Alignment.topRight,
                ),
                Spacer(),
                Container(
                  child:Text(dateFormat.format(joinRequest.date)),
                  alignment: Alignment.topLeft,
                ),

              ]
          ),
          Container(
            child:(){
              String userType = "מבקש עזרה";
              if(joinRequest.type == Privilege.Volunteer)
                userType = "מתנדב";
              else if(joinRequest.type == Privilege.Admin)
                userType = "מנהל";
              return Text( " רוצה להירשם כ" + userType , style:TextStyle(color: BasicColor.clr));
            }() ,
            alignment: Alignment.topRight,
          ),
        ],
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
  final _AdminJoinRequestsFeedState feedWidgetObject;

  @override
  Widget build(BuildContext context) {
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();
    return Container(
      //this color is to make the corners look transparent to the main screen: Color(0xFF696969)
      color: Color(0xFF696969),
      height: MediaQuery.of(context).size.height /1.5,
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
                    if(joinRequest.type == Privilege.Volunteer)
                      userType = "מתנדב";
                    else if(joinRequest.type == Privilege.Admin)
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
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "שם: " + joinRequest.sender.name,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Arial"
                    ),
                    maxLines: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "אימייל: " + joinRequest.sender.email,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Arial"
                    ),
                    maxLines: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "ת.ז: " + joinRequest.sender.id,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Arial"
                    ),
                    maxLines: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "מספר: " + joinRequest.sender.phoneNumber,
                    style: TextStyle(
                        fontSize: 15,
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

                          //TODO:CHANGE CATEGORES
                          feedWidgetObject.handleAcceptVerificationRequest(joinRequest, null);
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
                          //todo: pass a list of the categories if the user is a volunteer
                          DataBaseService().DenyVerficationRequest(joinRequest);
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


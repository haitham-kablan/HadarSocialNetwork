//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/getters/getUserName.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpRequestTile extends StatefulWidget {
  final Widget helpRequestWidget;
  HelpRequestTile({this.helpRequestWidget});

  @override
  _HelpRequestTileState createState() => _HelpRequestTileState();
}

class _HelpRequestTileState extends State<HelpRequestTile> {
  _HelpRequestTileState();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: Colors.brown[30],
        child: widget.helpRequestWidget,
      ),
    );
  }
}



class VolunteerFeedTile extends StatefulWidget {
  final HelpRequest helpRequest;

  VolunteerFeedTile(this.helpRequest);
  @override
  _VolunteerFeedTileState createState() => _VolunteerFeedTileState();
}

class _VolunteerFeedTileState extends State<VolunteerFeedTile> {

  @override
  Widget build(BuildContext context) {
    final DateTime now = widget.helpRequest.date;
    final DateFormat formatter = DateFormat.yMd().add_Hm();
    Color color = widget.helpRequest.handler_id == '' ? Colors.white : BasicColor.stam;
    return ListTile(
      tileColor: color,
      onTap: () => print("List tile pressed!"),//showHelpRequestStatus(helpRequest),
      isThreeLine: false,
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
                          Spacer(),
                          Spacer(),
                          CallWidget(widget.helpRequest),
                          ThreeDotsWidget(widget.helpRequest)]
                ),
                HebrewText(widget.helpRequest.description),
              ]
          )
      ),
//      trailing:
//          Row(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              //CallWidget(widget.helpRequest),
//             // ThreeDotsWidget(widget.helpRequest),
//
//            ],
//          ),
//
    );
  }
}




class CallWidget extends StatelessWidget {
  final HelpRequest helpRequest;

  CallWidget(this.helpRequest);

  _launchCaller() async {
    UserInNeed usr = await (DataBaseService().getUserById(
        helpRequest.sender_id, Privilege.UserInNeed)) as UserInNeed;
    String number = usr.phoneNumber;
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

class ThreeDotsWidget extends StatelessWidget {

  HelpRequest helpRequest;
  ThreeDotsWidget(this.helpRequest);


  Offset _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: () => print("Tap: more_vert"),
      onTapDown: _storePosition,
      onTap: () async {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject();
        final int _selected = await showMenu(
          items: [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                   HebrewText("קבל בקשה     "),
                ],
              ),
            ),
//            PopupMenuItem(
//                value: 2,
//                child: Row(children: <Widget>[
//                  const Icon(Icons.clear, color: Colors.red),
//                  const Text("   Deny"),
//                ])),
            PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.person),
                  HebrewText("משתמש     "),
                ],
              ),
            )
          ],
          context: context,
          position: RelativeRect.fromRect(
              _tapPosition & const Size(40, 40), // smaller rect, the touch area
              Offset.zero & overlay.size // Bigger rect, the entire screen
              ),
        );
        switch (_selected) {
          case 1:
            print("accept seleted");
           // helpRequest.handler_id = '4';
            List<HelpRequestType> list1 = List<HelpRequestType>();
            list1.add(HelpRequestType('food'));
            list1.add(HelpRequestType('money'));
            DataBaseService().assignHelpRequestForVolunteer(CurrentUser.curr_user as Volunteer, helpRequest);
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => testing_stream()),
//                      );
            break;
//          case 2:
//            print("deny seleted");
//            break;
          case 3:
            print("profile selected");
            break;
        }
      },
      child: Icon(
        Icons.more_vert,
        size: 20.0,
        color: Colors.brown[900],
      ),
    );
  }
}

class HelpRequestStatusWidget extends StatelessWidget {
  HelpRequestStatusWidget(this.helpRequest)
      : super(key: ObjectKey(helpRequest));

  final HelpRequest helpRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: BasicColor.backgroundClr,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                //width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.bottomRight,
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    helpRequest.category.description + ":",
                    style: TextStyle(
                        fontSize: 30,
                        color: BasicColor.clr,
                        fontFamily: "Arial"),
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
                        fontSize: 20, color: Colors.black, fontFamily: "Arial"),
                    maxLines: 10,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 140,
//              padding: const EdgeInsets.only(left: 20),

                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, //Center Row contents vertically,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            print("Accepted");
                          },
                          child: HebrewText('קבל בקשה'),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () {
                            print("Deny");
                          },
                          child: Text('Deny'),
                        ),
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}


import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/getters/getUserName.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../HelpRequestAdminDialouge.dart';





class AdminHelpRequestsFeed extends StatelessWidget {
  final Admin curr_user;
  AdminHelpRequestsFeed(this.curr_user);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HelpRequest>>.value(
      value: DataBaseService().getAll_unverfied_requests_Requests(),
      child: _AdminHelpRequestsFeed(),
    );
  }
}



class _AdminHelpRequestsFeed extends StatefulWidget {
  @override
  _AdminHelpRequestsFeedState createState() => _AdminHelpRequestsFeedState();
}

class _AdminHelpRequestsFeedState extends State<_AdminHelpRequestsFeed> {
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
              return FeedTile(helpRequestWidget: AdminHelpRequestFeedTile(requests[index]));
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
    final intl.DateFormat formatter = intl.DateFormat.yMd().add_Hm();
    Color color =  Colors.white ;
    return ListTile(
      tileColor: color,
     // onTap: () => print("List tile pressed!"),//showHelpRequestStatus(helpRequest),
      onTap: () => HelpRequestAdminDialuge(context,widget.helpRequest)   ,
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
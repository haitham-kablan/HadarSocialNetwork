import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';


class HelperFeed extends StatefulWidget {
  @override
  _HelperFeedState createState() => _HelperFeedState();
}

class _HelperFeedState extends State<HelperFeed> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<HelpRequest>>(context);

    return ListView.builder(
      itemCount: (requests == null) ? 0 : requests.length,
      itemBuilder: (context,index){
        return HelpRequestTile(helpRequestWidget: VolunteerFeedTile(requests[index]));
      },
    );
  }

}


class VolunteerFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<HelpRequestType> list1 = List<HelpRequestType>();
    list1.add(HelpRequestType('food'));
    list1.add(HelpRequestType('money'));

    return StreamProvider<List<HelpRequest>>.value(
      value: DataBaseService().getVolPendingRequests(Volunteer('hsen', 'sa', '123', false, '4', list1)),
      child: Scaffold(
        backgroundColor: BasicColor.BackgroundClr,
        appBar: AppBar(
          title: Text('Volunteer Feed'),
          backgroundColor: BasicColor.HelperClr,
          elevation: 0.0,
        ),
        body: HelperFeed(),
      ),
    );
  }
}



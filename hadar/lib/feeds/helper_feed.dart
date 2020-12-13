import 'package:flutter/material.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
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
        return HelpRequestTile(helpRequest: requests[index]);
      },
    );
  }

  void PrintMenu(){
    print("111");
  }
}

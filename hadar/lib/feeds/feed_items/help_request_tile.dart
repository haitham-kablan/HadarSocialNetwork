import 'package:flutter/material.dart';
import 'package:hadar/utils/HelpRequest.dart';

class HelpRequestTile extends StatelessWidget {

  final HelpRequest helpRequest;
  HelpRequestTile({this.helpRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown,
          ),
          title: Text(helpRequest.category),
          subtitle: Text(helpRequest.description),
        ),
      ),
    );
  }
}


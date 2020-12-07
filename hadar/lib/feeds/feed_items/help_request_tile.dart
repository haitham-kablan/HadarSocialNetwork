import 'package:flutter/material.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:intl/intl.dart';

class HelpRequestTile extends StatefulWidget {

  final HelpRequest helpRequest;
  HelpRequestTile({this.helpRequest});

  @override
  _HelpRequestTileState createState() => _HelpRequestTileState();
}




class _HelpRequestTileState extends State<HelpRequestTile> {


  _HelpRequestTileState();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  //final String formatted = formatter.format(now);


  @override
  Widget build(BuildContext context) {
    Offset _tapPosition;
    void _storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          //dense: true,
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown,
          ),
          isThreeLine: true,
          title: Text(widget.helpRequest.category.description),
          subtitle: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Text(widget.helpRequest.date.toString()),
                Text(formatter.format(now)),
                Text(widget.helpRequest.description),
              ]
            )
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () => print("Tap: call"),
                onLongPress: () => print("Long Press: Call"),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.call,
                        size: 20.0,
                        color: Colors.brown[900],
                        )
                ),
              ),
              GestureDetector(
                onTap: () => print("Tap: more_vert"),
                onTapDown: _storePosition,
                onLongPress: () async {
                  final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject();
                  final int _selected = await showMenu(
                    items: [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.done,
                                      color: Colors.green,),
                            const Text("   Accept"),

                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.clear,
                                      color: Colors.red),
                            const Text("   Deny"),
                          ]
                        )
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.person),
                            const Text("   Profile"),
                          ],
                        ),
                      )
                    ],
                    context: context,
                    position: RelativeRect.fromRect(
                        _tapPosition &
                        const Size(40, 40), // smaller rect, the touch area
                        Offset.zero & overlay.size // Bigger rect, the entire screen
                    ),
                  );
                  switch (_selected) {
                    case 1:
                      print("accept seleted");

//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => testing_stream()),
//                      );
                      break;
                    case 2:
                      print("deny seleted");
                      break;
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
              ),
            ],
          ),
        ),
      ),
    );
  }

}

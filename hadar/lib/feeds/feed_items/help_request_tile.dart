import 'package:flutter/material.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/utils/HelpRequest.dart';


class HelpRequestTile extends StatelessWidget {

  final HelpRequest helpRequest;
  HelpRequestTile({this.helpRequest});
  var _count = 0;
  var _tapPosition;


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
          title: Text(helpRequest.category.description),
          subtitle: Text(helpRequest.date.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.call,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {

                },

              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                  //   _onDeleteItemPressed(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}): super(key:key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {


  var _count = 0;
  var _tapPosition;

  void _showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
        context: context,
        items: <PopupMenuEntry<int>>[PlusMinusEntry()],
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size   // Bigger rect, the entire screen
        )
    )
    // This is how you handle user selection
        .then<void>((int delta) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)
      if (delta == null) return;

      setState(() {
        _count = _count + delta;
      });
    });

    // Another option:
    //
    // final delta = await showMenu(...);
    //
    // Then process `delta` however you want.
    // Remember to make the surrounding function `async`, that is:
    //
    // void _showCustomMenu() async { ... }
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }





  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PlusMinusEntry extends PopupMenuEntry<int> {
  @override
  double height = 100;
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int n) => n == 1 || n == -1;

  @override
  PlusMinusEntryState createState() => PlusMinusEntryState();
}

class PlusMinusEntryState extends State<PlusMinusEntry> {
  void _plus1() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context, 1);
  }

  void _minus1() {
    Navigator.pop<int>(context, -1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _plus1, child: Text('+1'))),
        Expanded(child: FlatButton(onPressed: _minus1, child: Text('-1'))),
      ],
    );
  }
}
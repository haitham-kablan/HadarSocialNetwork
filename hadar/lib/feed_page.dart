import 'package:flutter/material.dart';

class Show_Feed_Page extends StatelessWidget {
  static const String _title = 'Home Page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: const Text('Feed Page'),
//      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          //return PostCard();
          return feed();
        },
      ),
    );
  }
}

class feed extends StatefulWidget {
  feed({Key key}) : super(key: key);



  @override
  _feed createState() => _feed();
}

class _feed extends State<feed>{
    //const feed({Key key}) : super (key : key);
    var _count;
    var _tapPosition;

    void _showCustomMenu() {
      final RenderBox overlay = Overlay
          .of(context)
          .context
          .findRenderObject();
      showMenu(
          context: context,
          items: <PopupMenuEntry<int>>[NavigateEntry()],
          position: RelativeRect.fromRect(
              _tapPosition & const Size(40, 40), // smaller rect, the touch area
              Offset.zero & overlay.size // Bigger rect, the entire screen
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
    }

    void _storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

      @override
    Widget build(BuildContext context) {
          return AspectRatio(
              aspectRatio: 5/2,
              child:Card(
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                    // This does not give the tap position ...
                    onLongPress: _showCustomMenu,

                    // Have to remember it on tap-down.
                    onTapDown: _storePosition,

                    child: Container(
                          width: 300,
                          height: 100,
                          child: Column(children: <Widget>[_Post()]),
                      ),
                  ),
              ),
          );
  }

}

class NavigateEntry extends PopupMenuEntry<int> {
  @override
  double height = 100;
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int n) => n == 1 || n == -1;

  @override
  NavigateEntryState createState() => NavigateEntryState();
}

class NavigateEntryState extends State<NavigateEntry> {
  void _stats() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context);
  }
  void _profile() {
    Navigator.pop<int>(context);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _stats, child: Text('Stats'))),
        Expanded(child: FlatButton(onPressed: _profile, child: Text('Profile'))),
      ],
    );
  }
}





class _Post extends StatelessWidget {
  const _Post({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: <Widget>[_PostTitleAndSummary()],
      ),
    );
  }
}

class _PostTitleAndSummary extends StatelessWidget {
  const _PostTitleAndSummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    const TextStyle optionStyle1 = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
    final String title = DemoValues.postTitle;
    final String summary = DemoValues.postSummary;

    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title, style: optionStyle),
          Text(summary, style: optionStyle1,),
        ],
      ),
    );
  }
}

class DemoValues {
  static final String postTitle = "Post";
  static final String postSummary = "I need some help SOS";
}
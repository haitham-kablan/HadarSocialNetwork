import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/utils/HelpRequest.dart';

class ButtonDesign extends StatelessWidget {
  ButtonDesign({this.title, this.parent}) : super(key: ObjectKey(title));

  final title;
  final HelpRequestFeedState parent;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
      child: Text(title),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DescriptonBox(title: title, parent: parent),
        ),
      ),
    );
  }
}

class HelpWindow extends StatelessWidget {
  static const String _title = 'helpWindow';

  final HelpRequestFeedState parent;

  HelpWindow(this.parent);

  @override
  Widget build(BuildContext context) {
    final title = 'Help Categories';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: [
            ButtonDesign(title: 'Groceries', parent: parent),
            ButtonDesign(title: 'Health issues', parent: parent),
            ButtonDesign(title: 'BabySitter', parent: parent),
            ButtonDesign(title: 'Dentist', parent: parent),
            ButtonDesign(title: 'Food', parent: parent),
          ],
        ),
      ),
    );
  }
}
/*
class UserInNeedFeed extends StatelessWidget {
  static const String _title = 'Feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('I need help'),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpWindow()),
            )
          },
        ),
      ),
    );
  }
}
*/

//when a user clicks on the category, he gets a description box,
// where he can describe his request
class DescriptonBox extends StatefulWidget {
  DescriptonBox({Key key, this.title, this.parent}) : super(key: key);
  final String title;
  final HelpRequestFeedState parent;

  @override
  _DescriptonBox createState() => _DescriptonBox();
}

class _DescriptonBox extends State<DescriptonBox> {
  String _inputtext = 'waiting..';
  HelpRequest helpRequest;
  TextEditingController inputtextField = TextEditingController();

  void _processText() {
    setState(() {
      _inputtext = inputtextField.text;
      helpRequest = HelpRequest(
          widget.title, _inputtext, DateTime.now().toString(), "sender");
      widget.parent.handleFeedChange(helpRequest, true);
      //todo: push to database
      if (Navigator.canPop(context)) {
        Navigator.pop(
          context,
        );
      }
      if (Navigator.canPop(context)) {
        Navigator.pop(
          context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: inputtextField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Description'),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$_inputtext',
                style: Theme.of(context).textTheme.display1,
              ),
            ),*/
            RaisedButton(
              onPressed: _processText,
              child: Text('Done'),
            )
          ],
        ),
      ),
    );
  }
}

//show/hide, not used yet..
//when clicking on a post a slide sheet appears with the options of renew, and
//track the request
//will be used after the feed is implemented
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void slideSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[Text('Renew')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[Text('Track')],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: slideSheet,
          child: Text('Click'),
        ),
      ),
    );
  }
}

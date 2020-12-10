import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:provider/provider.dart';

class RequestWindow extends StatelessWidget {
  final HelpRequestFeedState parent;

  RequestWindow(this.parent);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choose a category',
//      theme: ThemeData(
//        primarySwatch: Colors.teal,
//      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: BasicColor.userInNeedClr,
          title: Row(
            children: [
              Center(
                child: Text("Choose a category"),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 170,
              ),
              Container(
                height: 100,
                child: Dropdown(),
              ),
              Container(
                height: 140,
                child: DescriptonBox(title: 'Description', parent: parent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dropdown extends StatefulWidget {
  State createState() => DropDownState();
}

class DropDownState extends State<Dropdown> {
  List<HelpRequestType> types = <HelpRequestType>[
    HelpRequestType('Groceries'),
    HelpRequestType('Food'),
    HelpRequestType('Dentist'),
    HelpRequestType('Babysitting'),
    HelpRequestType('Health issues')
  ];
  HelpRequestType selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButton<HelpRequestType>(
          hint: Text("Select a category"),
          value: selectedType,
          onChanged: (HelpRequestType Value) {
            setState(() {
              selectedType = Value;
            });
          },
          items: types.map((HelpRequestType type) {
            return DropdownMenuItem<HelpRequestType>(
              value: type,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    type.description,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

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
  HelpRequestType helpRequestType;

  void _processText() {
    setState(() {
      _inputtext = inputtextField.text;
      helpRequestType = HelpRequestType(_inputtext);
      helpRequest =
          HelpRequest(helpRequestType, _inputtext, DateTime.now(), "sender");
      widget.parent.handleFeedChange(helpRequest, true);
      //todo: push to database
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: inputtextField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: widget.title),
              ),
            ),
            RaisedButton(
              onPressed: _processText,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
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

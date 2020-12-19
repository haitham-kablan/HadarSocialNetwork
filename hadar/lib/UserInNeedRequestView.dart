import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:provider/provider.dart';

import 'Design/mainDesign.dart';

class RequestWindow extends StatelessWidget {
  HelpRequestFeedState parent;
  DescriptonBox desBox;
  Dropdown drop;
  List<HelpRequestType> types;

  RequestWindow(HelpRequestFeedState parent, List<HelpRequestType> types) {
    this.parent = parent;
    this.types = types;
    init();
  }

  void init() {
    this.desBox = DescriptonBox(title: 'פירוט', parent: parent);
    this.drop = Dropdown(desBox, types);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 150, title: 'בחר קטיגוריה'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Container(
                    height: 100,
                    child: drop,
                  ),
                  Container(
                    height: 140,
                    child: desBox,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dropdown extends StatefulWidget {
  DescriptonBox desBox;
  DropDownState dropDownState;
  List<HelpRequestType> types;

  Dropdown(DescriptonBox desBox, List<HelpRequestType> types) {
    this.types = types;
    this.desBox = desBox;
    this.dropDownState = DropDownState(desBox, types);
  }

  @override
  State createState() => dropDownState;

  HelpRequestType getSelectedType() {
    return dropDownState.getSelectedType();
  }
}

class DropDownState extends State<Dropdown> {
  HelpRequestType selectedType;
  DescriptonBox desBox;
  List<HelpRequestType> types;

  DropDownState(DescriptonBox desBox, List<HelpRequestType> types) {
    this.desBox = desBox;
    this.types = types;
  }

  HelpRequestType getSelectedType() {
    return selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DropdownButton<HelpRequestType>(
          hint: HebrewText("בחר קטיגוריה"),
          value: selectedType,
          onChanged: (HelpRequestType Value) {
            setState(
              () {
                selectedType = Value;
                desBox.setSelectedType(selectedType);
              },
            );
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
  _DescriptonBox desBoxState = _DescriptonBox();
  final String title;
  final HelpRequestFeedState parent;

  void setSelectedType(HelpRequestType selectedType) {
    desBoxState.setSelectedType(selectedType);
  }

  @override
  _DescriptonBox createState() => desBoxState;
}

class _DescriptonBox extends State<DescriptonBox> {
  String _inputtext = 'waiting..';
  HelpRequest helpRequest;
  TextEditingController inputtextField = TextEditingController();
  HelpRequestType helpRequestType;

  void setSelectedType(HelpRequestType selectedType) {
    setState(() {
      _inputtext = selectedType.description;
    });
  }

  void _processText() {
    setState(() {
      helpRequestType = HelpRequestType(_inputtext);
      _inputtext = inputtextField.text;
      helpRequest =
          HelpRequest(helpRequestType, _inputtext, DateTime.now(), CurrentUser.curr_user.id,"");
      print("input text" + _inputtext);
      print("helpRequest" + helpRequestType.description);

      widget.parent.handleFeedChange(helpRequest, true);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => UserInNeedHelpRequestsFeed()),);
      // if (Navigator.canPop(context)) {
      //   Navigator.pop(
      //     context,
      //   );
      // }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return StreamProvider<List<HelpRequest>>.value(
            value: DataBaseService().getUserHelpRequests(CurrentUser.curr_user as UserInNeed),
            child: UserInNeedHelpRequestsFeed(),
          );
        }),
      );
    }
    );
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
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: inputtextField,
                      textAlign: TextAlign.right,
                      autofocus: true,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: widget.title,
                      ),
                    ))),
            RaisedButton(
              onPressed: () {
                _processText();
              },
              child: Text('אישור'),
            )
          ],
        ),
      ),
    );
  }
}

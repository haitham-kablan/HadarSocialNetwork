import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/lang/HebrewText.dart';

import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:intl/intl.dart' as Intl;
import 'package:provider/provider.dart';

import 'Design/mainDesign.dart';
import 'adminProfile.dart';
import 'feeds/user_inneed_feed.dart';

class AdminRequestWindow extends StatelessWidget {
  AdminProfile parent;
  DescriptonBox desBox;
  DescriptonBox desUser;
  DescriptonBox desId;
  Dropdown drop;
  List<HelpRequestType> types;

  AdminRequestWindow(AdminProfile parent, List<HelpRequestType> types) {
    this.parent = parent;
    this.types = types;
    init();
  }

  void init() {
    this.desBox = DescriptonBox(title: 'פירוט', parent: parent);
    this.desUser = DescriptonBox(title: 'תיאור משתמש', parent: parent);
    this.desId = DescriptonBox(title: 'תעודת זהות', parent: parent);
    this.drop = Dropdown(desBox, types);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 150, title: 'בחר קטיגוריה'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column( children:[
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 100,
                    child: desUser,
                  ),
                  Container(
                    height: 100,
                    child: desId,
                  ),
                    Container(
                      height: 50,
                      child: drop,
                    ),
                    Container(
                      height: 100,
                      child: desBox,
                    ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    onPressed: () {
                      desBox.processText();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminProfile()),
                      );
                    },
                    child: Text('אישור'),
                  ),
                  ],
                ),
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
        child: Directionality(
          textDirection: TextDirection.rtl,
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
  final AdminProfile parent;

  void setSelectedType(HelpRequestType selectedType) {
    desBoxState.setSelectedType(selectedType);
  }

  void processText() {
    desBoxState.processText();
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

  void processText() {
    setState(() {
      // helpRequestType = HelpRequestType(_inputtext);
      // _inputtext = inputtextField.text;
      // helpRequest = HelpRequest(helpRequestType, _inputtext, DateTime.now(),
      //     CurrentUser.curr_user.id, '', Status.UNVERFIED);
      // print("input text" + _inputtext);
      // print("helpRequest" + helpRequestType.description);
      // //todo add request to data base
      //
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AdminProfile()),
      // );
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
                padding: const EdgeInsets.all(18.0),
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
            // RaisedButton(
            //   onPressed: () {
            //     _processText();
            //   },
            //   child: Text('אישור'),
            // )
          ],
        ),
      ),
    );
  }
}

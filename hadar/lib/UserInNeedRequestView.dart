import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/lang/HebrewText.dart';

import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:provider/provider.dart';

import 'Design/mainDesign.dart';
import 'feeds/OrganizationFeed.dart';
import 'feeds/user_inneed_feed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestWindow extends StatelessWidget {
  HelpRequestFeedState parent;
  DescriptonBox desBox;

  Dropdown drop;
  List<HelpRequestType> types;
  static TextEditingController location_controller = TextEditingController();

  RequestWindow(HelpRequestFeedState parent, List<HelpRequestType> types) {
    this.parent = parent;
    this.types = types;
    init();
  }

  void init() {
    this.desBox = DescriptonBox(title: AppLocalizations.of(parent.context).explanation, parent: parent);

    this.drop = Dropdown(desBox, types);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: BasicColor.backgroundClr,
        bottomNavigationBar: BottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 150, title: AppLocalizations.of(context).chooseCategory),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
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
                      margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: TextFormField(
                        textAlign: TextAlign.right,
                        controller: RequestWindow.location_controller,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: BasicColor.clr),
                            ),

                            hintText:  AppLocalizations.of(context).changeRequestLocation,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )
                        ),
                      ),
                    ),
                    Container(
                      height: 140,
                      child: desBox,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, right: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context).organizationServices,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: BasicColor.clr,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      ),

                    ),
                    Container(
                      height: 300,
                        child: OrganizationsInfoList()
                    ),



                  ],
                ),
              ),
            ),
          ],
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
            hint: Text(AppLocalizations.of(context).chooseCategory),
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
          HelpRequest(helpRequestType, _inputtext, DateTime.now(), CurrentUser.curr_user.id,'',Status.UNVERFIED,RequestWindow.location_controller.text.isEmpty ? (CurrentUser.curr_user as UserInNeed).Location: RequestWindow.location_controller.text);
      print("input text" + _inputtext);
      print("helpRequest" + helpRequestType.description);

      widget.parent.handleFeedChange(helpRequest, true);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => UserInNeedHelpRequestsFeed()),);
      // if (Navigator.canPop(context)) {
      //   Navigator.pop(
      //     context,
      //   );
      // }
      returnToFeed();
    }
    );
  }

  void returnToFeed() {
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                RaisedButton(
                  onPressed: () {
                    returnToFeed();
                  },
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                SizedBox(
                  width: 25,
                ),
                RaisedButton(
                  onPressed: () {
                    _processText();
                  },
                  child: Text(AppLocalizations.of(context).approve),
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }
}

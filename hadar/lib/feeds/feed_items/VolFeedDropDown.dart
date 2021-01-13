import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/utils/HelpRequestType.dart';

class Dropdown extends StatefulWidget {

  DropDownState dropDownState;
  List<HelpRequestType> types;

  Dropdown( List<HelpRequestType> types) {
    this.types = types;
    this.dropDownState = DropDownState( types);
  }

  @override
  State createState() => dropDownState;

  HelpRequestType getSelectedType() {
    return dropDownState.getSelectedType();
  }
}

class DropDownState extends State<Dropdown> {
  HelpRequestType selectedType;

  List<HelpRequestType> types;

  DropDownState(List<HelpRequestType> types) {

    this.types = types;
  }

  HelpRequestType getSelectedType() {
    return selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColor.backgroundClr,
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
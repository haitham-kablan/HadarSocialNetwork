import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({Key key}) : super(key: key);

  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          if(isSwitched){
            //TODO: turn notifications on
            print("notification switch is on ");
          }
          else{
            //TODO: turn notifications off
            print("notification switch is off ");
          }
        });
      },
      activeTrackColor: BasicColor.clr,
      activeColor: BasicColor.backgroundClr,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/WorkmanagerHandling.dart';
import 'package:hadar/users/CurrentUser.dart';

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({Key key}) : super(key: key);

  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool isSwitched = CurrentUser.curr_user.lastNotifiedTime != -1;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          if(isSwitched){
            //turn notifications on
            initWorkmanager();
            CurrentUser.curr_user.lastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
            print("notification switch is on ");
          }
          else{
            //turn notifications off
            WorkManagerInst.instance.cancelAll();
            // DataBaseService().updateUserLastNotifiedTime(CurrentUser.curr_user, turnOffNotifications: true);
            print("notification switch is off ");
          }
        });
      },
      activeTrackColor: BasicColor.clr,
      activeColor: BasicColor.backgroundClr,
    );
  }
}

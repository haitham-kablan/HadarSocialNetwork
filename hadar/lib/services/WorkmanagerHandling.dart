import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hadar/services/NotificationsHandling.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hadar/users/User.dart';

import 'DataBaseServices.dart';

class WorkManagerInst{
  static Workmanager instance = new Workmanager();
}
void initWorkmanager(){
  //WorkManagerInst.instance = new Workmanager();
  WorkManagerInst.instance.initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true
  );

  // Periodic task registration
  WorkManagerInst.instance.registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "notificationHandler",
      initialDelay: Duration(seconds: 15),

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );
}

void callbackDispatcher() {
  WorkManagerInst.instance.executeTask((task, inputData) async{

    await Firebase.initializeApp();
    User currUser = await DataBaseService().getCurrentUser();
    if(currUser == null){
      //cancel the task if there is no logged-in user
      WorkManagerInst.instance.cancelAll();
      return Future.value(true);
    }
    await initNotifications();

    int lastNotifiedTime = currUser.lastNotifiedTime;
    switch (currUser.privilege){
      case Privilege.Admin:

        // check if there are new join requests
        bool hasNewJoinRequests = await DataBaseService()
            .hasVerificationRequestsAfterTimestamp(lastNotifiedTime);
        if(hasNewJoinRequests){
          sendJoinRequestNotification();
        }

        // check if there are new help requests to be verified
        bool hasUnverifiedHelpRequests = await DataBaseService()
            .hasUnverifiedHelpRequestsAfter(lastNotifiedTime);
        if(hasUnverifiedHelpRequests){
          sendUnverifiedHelpReqNotification();
        }

        // check if there are new help requests that a volunteer has offered to help with
        bool hasApprovedHelpRequests = await DataBaseService()
            .hasApprovedHelpRequestsAfter(lastNotifiedTime);
        if(hasApprovedHelpRequests){
          sendApprovedHelpReqNotification();
        }

        //todo: should we check for new inquiries and notify the admin if needed?

        //update the lastNotifiedTime for the admin to the current time
        //this must be done lastly
        DataBaseService().updateUserLastNotifiedTime(currUser);
        break;

      case Privilege.Volunteer:
        bool hasAvailableHelpRequests = await DataBaseService()
            .hasAvailableHelpRequestsAfter(lastNotifiedTime);
        if(hasAvailableHelpRequests){
          sendVolHelpReqNotification();
        }

        //update the lastNotifiedTime for the admin to the current time
        //this must be done lastly
        DataBaseService().updateUserLastNotifiedTime(currUser);
        return Future.value(true);

      default:
        //cancel all tasks in WorkManager to stop checking for notifications
        WorkManagerInst.instance.cancelAll();
        return Future.value(true);
    }
    return Future.value(true);
  });
}
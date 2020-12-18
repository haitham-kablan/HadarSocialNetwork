import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Log_In_Screen(),
  ));
}

class Log_In_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BasicColor.backgroundClr,
        appBar: AppBar(
          backgroundColor: BasicColor.backgroundClr,
          title: Text('Hadar',
            style: TextStyle(
              color: BasicColor.backgroundClr,
              fontSize: 30,
            ),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: RaisedButton(
                child: Text("go to volunteer feed"),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VolunteerFeed()),
                  );
                },
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text("go to user in_need feed"),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          // User(this.name, this.phoneNumber, this.email, this.privilege , this.id
                                // );
                          return StreamProvider<List<HelpRequest>>.value(
                            value: DataBaseService().getUserHelpRequests(User("haitham", "099000","no_need",Privilege.UserInNeed,"123456789")),
                            child: UserInNeedHelpRequestsFeed(),
                          );
                        }
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}



/*
class TmpClass extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(backgroundColor: BasicColor.BackgroundClr,);
  }
}

class stackedPages extends StatelessWidget {
  Widget page;
  stackedPages(this.page);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          page,
          BackgroundDesign()
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: stackedPages(TmpClass()),
  ));
}
*/
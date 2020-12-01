

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:provider/provider.dart';


import 'package:hadar/home_page.dart';



import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Hadar'),
        centerTitle: true,
      ),
      body: Column(
      children: [
       Center(

          child: RaisedButton(
            child: Text("go to volunteer feed"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home_Page_Screen()),
              );
            },
          ),
        ),
        Center(

          child: RaisedButton(
            child: Text("go to user in_need feed"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home_Page_Screen()),
              );
            },
          ),
        ),
      ],
      )

    );
  }
}



class tmp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HelpRequest>>.value(
      value: DataBaseService().get_User_Help_Requests('haitham'),
      child: Scaffold(
        backgroundColor: Colors.brown[50],

        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
            ),
          ],
        ),
        body: HelperFeed(),
      ),
    );
  }
}



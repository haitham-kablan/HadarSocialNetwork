
import 'package:flutter/material.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Custom_Text_feild('שם משתמש',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Custom_Text_feild('סיסמה',Icon(Icons.lock),Colors.purple,Colors.orange),
            RaisedButton(
              onPressed: () {  },
              child: Text('log in'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReigesterPage()));
              },
              child: Text('sign up'),
            ),
          ],
        ),
      ),
    );
  }
}







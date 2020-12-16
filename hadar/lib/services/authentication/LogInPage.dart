
//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';
import 'package:hadar/services/authentication/validators.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  var email_control = TextEditingController();
  var pw_control = TextEditingController();
  final paswwordKey = GlobalKey<FormState>();
  final nameKey = GlobalKey<FormState>();
  String _error = null;

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Color(0xff494CF5),
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(Icons.close,color: Colors.white,),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            ),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.error_outline , color: Colors.white),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          children: [
            Container(
              child: this.showAlert(),
              margin: EdgeInsets.all(40),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                'ברכוים הבאים',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 80),
              child:Form(key:nameKey,child: Custom_Text_feild('שם משתמש',Icon(Icons.account_circle_rounded),Color(0xff494CF5),Colors.black,Email_Validator.Validate,email_control,false)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Form(key: paswwordKey , child: Custom_Text_feild('סיסמה',Icon(Icons.lock),Color(0xff494CF5),Colors.black,password_Validator.Validate,pw_control,true)),
            ),

            Container(
              margin: EdgeInsets.only(top: 60),
              child: RaisedButton(
                color: Color(0xff494CF5),
                splashColor: Colors.white,
                child: Text('כניסה',style: TextStyle(fontSize: 18 , color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                onPressed: () async {
                  if(!nameKey.currentState.validate() || !paswwordKey.currentState.validate() ){
                        return;
                  }
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email_control.text,
                        password: pw_control.text
                    );
                    email_control.clear();
                    pw_control.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReigesterPage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      setState(() {
                        _error = 'לא נמצא שם משתמש כזה';
                      });

                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      setState(() {
                        _error = 'הסיסמה אינה מתאימה';
                      });

                    }
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Sign_up_here_text(),
            ),
          ],
        ),
      ),
    );
  }


}




class Sign_up_here_text extends StatelessWidget {
  TextStyle defaultStyle = TextStyle(color: Color(0xff494CF5), fontSize: 15 );
  TextStyle linkStyle = TextStyle(color: Color(0xff494CF5) , fontSize: 15 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: 'אין לך עדיין משתמש?',
            style: defaultStyle,),
          TextSpan(
              text: 'לחץ כאן להירשם',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReigesterPage()),
                  );
                }),
        ],
      ),
    );
  }
  
 
}




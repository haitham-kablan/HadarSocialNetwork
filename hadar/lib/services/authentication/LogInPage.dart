
//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/ReigsterPage.dart';
import 'package:hadar/services/authentication/google_sign_in_button.dart';
import 'package:hadar/services/authentication/provider/google_sign_in_provider.dart';
import 'package:hadar/services/authentication/validators.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import '../../HelpRequestAdminDialouge.dart';
import '../../main.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  var email_control = TextEditingController();
  var pw_control = TextEditingController();
  final paswwordKey = GlobalKey<FormState>();
  final nameKey = GlobalKey<FormState>();
  bool show_spinner = false;
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
                'ברוכים הבאים',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 80),
              child:Form(key:nameKey,child: Custom_Text_feild('שם משתמש',Icon(Icons.email),BasicColor.clr,Colors.black,Email_Validator.Validate,email_control,false,Colors.grey)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Form(key: paswwordKey , child: Custom_Text_feild('סיסמה',Icon(Icons.lock),BasicColor.clr,Colors.black,password_Validator.Validate,pw_control,true,Colors.grey)),
            ),

            Container(
              margin: EdgeInsets.only(top: 60),
              child: show_spinner ? SpinKitCircle(color: BasicColor.clr,) : RaisedButton(
                color: BasicColor.clr,
                splashColor: Colors.white,
                child: Text('כניסה',style: TextStyle(fontSize: 18 , color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                onPressed: () async {
                  if(!nameKey.currentState.validate() || !paswwordKey.currentState.validate() ){
                        return;
                  }
                  //TDOD : SWITCH PLACES
                  try {
                    setState(() {
                      show_spinner = true;
                    });
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email_control.text,
                        password: pw_control.text);

                    // if (!FirebaseAuth.instance.currentUser.emailVerified) {
                    //   await FirebaseAuth.instance.currentUser.sendEmailVerification();
                    //   FirebaseAuth.instance.signOut();
                    //   setState(() {
                    //     _error = 'נא לאמת את הקישור שנשלח לך במיל';
                    //     show_spinner = false;
                    //   });
                    //   return;
                    // }
                    bool is_verfied = await DataBaseService().checkIfVerfied(email_control.text);
                    if(!is_verfied){
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        _error = ' החשבון שלך עדיין לא אומת על יד המנהל';
                        show_spinner = false;
                      });
                      return;
                    }

                    print(FirebaseAuth.instance.currentUser);


                    Widget curr_widget = await CurrentUser.init_user();
                    DataBaseService().add_user_token_to_db();
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => curr_widget),
                    );
                    setState(() {
                      show_spinner = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      setState(() {
                        email_control.clear();
                        pw_control.clear();
                        _error = 'לא נמצא שם משתמש כזה';
                        show_spinner = false;
                      });

                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      setState(() {
                        email_control.clear();
                        pw_control.clear();
                        _error = 'הסיסמה אינה מתאימה';
                        show_spinner = false;
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
           //GoogleSignupButtonWidget(),
          ],
        ),
      ),
    );
  }


}




class Sign_up_here_text extends StatelessWidget {
  TextStyle defaultStyle = TextStyle(color: BasicColor.clr, fontSize: 15 );
  TextStyle linkStyle = TextStyle(color: BasicColor.clr , fontSize: 15 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline);
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




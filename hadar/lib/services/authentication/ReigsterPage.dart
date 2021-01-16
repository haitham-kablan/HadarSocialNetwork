import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/main.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/services/authentication/validators.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/VerificationRequest.dart';
import 'package:intl/intl.dart';

import 'forms/UserInNeedRegPage.dart';
import 'forms/VolunteerRegPage.dart';


class ReigesterPage extends StatefulWidget {
  @override
  _ReigesterPageState createState() => _ReigesterPageState();

}

class _ReigesterPageState extends State<ReigesterPage> {

  final nameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final paswwordKey = GlobalKey<FormState>();
  final secnd_pass_Key = GlobalKey<FormState>();
  final idKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormState>();
  String _error_msg = '';
  bool alert = false;
  bool clicked=false;
  Privilege clicked_priv = null;
  Map<String, Icon> tripTypes = user_types([Colors.grey , Colors.grey , Colors.grey]);
  List<String> tripKeys ;

  final name_Controller = TextEditingController();
  final id_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final first_pw_Controller = TextEditingController();
  final second_pw_Controller = TextEditingController();
  bool show_spinner = false;
  @override
  Widget build(BuildContext context) {

    List<String> tripKeys = tripTypes.keys.toList();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: get_bg(),
        ),
    );
  }

  Map<String, Icon> update_list(int index) {

    List<Color> new_clrs = [index == 0 ? BasicColor.clr : Colors.grey ,
      index == 1 ? BasicColor.clr : Colors.grey,
      index == 2 ? BasicColor.clr : Colors.grey];
    return user_types(new_clrs);
  }

  Widget showAlert() {
    if (alert) {
      return Container(
        color: BasicColor.clr,
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
                    alert = false;
                  });

                },
              ),
            ),
            Expanded(
              child: Text(
                _error_msg,
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

  Widget showAlert_as_col() {
    if (alert) {
      return Container(
        color: BasicColor.clr,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(65, 8, 65, 8),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(Icons.close,color: Colors.white,),
                onPressed: () {
                  setState(() {
                    alert = false;
                  });

                },
              ),
            ),
            Expanded(
              child: Text(
                _error_msg,
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
  Widget get_bg(){
    return  Column(
          children: [
            demo_bg(
              Column(
                children: [
                  SizedBox(height: 60),
                  Container(child: showAlert_as_col()),
                  Form(
                    child: Custom_Text_feild('שם מלא',Icon(Icons.account_circle_rounded,color: Colors.white ),Colors.white,Colors.white,name_Validator.Validate,name_Controller,false,Colors.white),
                    key: nameKey,
                  ),
                  Form(
                    child: Custom_Text_feild('תעודת זהות',Icon(Icons.arrow_left_outlined,color: Colors.white),Colors.white,Colors.white,Id_Validator.Validate,id_Controller,false,Colors.white),
                    key: idKey,
                  ),
                  Form(
                    child: Custom_Text_feild('מספר טלפון',Icon(Icons.phone,color: Colors.white),Colors.white,Colors.white,number_Validator.Validate,phone_Controller,false,Colors.white),
                    key: phoneKey,
                  ),
                  Form(
                    child: Custom_Text_feild('כתובת אימיל',Icon(Icons.email,color: Colors.white),Colors.white,Colors.white,Email_Validator.Validate,email_Controller,false,Colors.white),
                    key: emailKey,
                  ),
                  Form(
                    child: Custom_Text_feild('סיסמה',Icon(Icons.lock, color: Colors.white),Colors.white,Colors.white,password_Validator.Validate,first_pw_Controller,true,Colors.white),
                    key: paswwordKey,
                  ),
                  Form(
                    child: Custom_Text_feild('אימות סיסמה',Icon(Icons.lock,color: Colors.white),Colors.white,Colors.white,second_pw_Validator.Validate,second_pw_Controller,true,Colors.white),
                    key: secnd_pass_Key,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:30),
              child: Text(
                'נרשם בתור',
                style: TextStyle(
                  fontSize: 18,
                  color: BasicColor.clr,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,

              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: ()  {

                      setState(() {
                        tripTypes = update_list(0);
                        alert = false;
                        clicked=true;
                        clicked_priv = hadar.Privilege.Admin;
                      });
                    },
                    child: Column(
                      children: [
                        tripTypes["מנהל"],
                        Text('מנהל'),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        tripTypes = update_list(1);
                        alert = false;
                        clicked=true;
                        clicked_priv = hadar.Privilege.UserInNeed;
                      });
                    },
                    child: Column(
                      children: [
                        tripTypes["מבקש עזרה"],
                        Text('מבקש עזרה'),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        tripTypes = update_list(2);
                        alert = false;
                        clicked=true;
                        clicked_priv = hadar.Privilege.Volunteer;
                      });
                    },
                    child: Column(
                      children: [
                        tripTypes["עוזר"],
                        Text('עוזר'),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            Container(
              margin: EdgeInsets.all(10),
              child: show_spinner ? SpinKitCircle(color: BasicColor.clr,) :RaisedButton(
                color: BasicColor.clr,
                splashColor: Colors.white,
                child: Text('הרשמה',style: TextStyle(fontSize: 18 , color: Colors.white),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                onPressed: () async {
                  second_pw_Validator.First_pw = first_pw_Controller.text;
                  if(!nameKey.currentState.validate() ||!idKey.currentState.validate() ||!phoneKey.currentState.validate()
                      ||!emailKey.currentState.validate() || !paswwordKey.currentState.validate()
                      ||!secnd_pass_Key.currentState.validate()
                  ){
                    return;
                  }
                  setState(() {
                    show_spinner = true;
                  });
                  bool id_check_if_exsist = await DataBaseService().is_id_taken(id_Controller.text,email_Controller.text);
                  if(id_check_if_exsist){
                    setState(() {
                      alert=true;
                      show_spinner = false;
                      _error_msg = 'תעודת הזהות כבר תפוסה';

                    });
                    return;
                  }
                  if(clicked == false){
                    setState(() {
                      alert=true;
                      show_spinner = false;
                      _error_msg = 'אנא בחר את התור שלך';

                    });
                    return;
                  }
                  assert (clicked_priv != null);
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email_Controller.text,
                        password: first_pw_Controller.text
                    );
                    UserInNeed user_in_need;
                    Volunteer volunteer;
                    if(clicked_priv == hadar.Privilege.UserInNeed){
                      user_in_need = UserInNeed(name_Controller.text, phone_Controller.text, email_Controller.text, false, id_Controller.text,0,'','',0,'','','','');

                      Navigator.push(context, MaterialPageRoute(builder: (context) => userInNeedRegisterPage(user_in_need)));
                    }else if (clicked_priv == hadar.Privilege.Admin){
                      DataBaseService().addVerficationRequestToDb(VerificationRequest(UnregisteredUser(name_Controller.text, phone_Controller.text, email_Controller.text, id_Controller.text),  clicked_priv, DateTime.now()));
                      Navigator.pop(context);
                    }else{
                      volunteer = Volunteer(name_Controller.text, phone_Controller.text, email_Controller.text, false, id_Controller.text,'',0,'','','','','','','','');

                      Navigator.push(context, MaterialPageRoute(builder: (context) => volunteerRegisterPage(volunteer)));
                    }


                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      setState(() {
                        alert=true;
                        show_spinner = false;
                        _error_msg = 'הסיסמה שלך חלשה';
                      });
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        alert=true;
                        show_spinner = false;
                        _error_msg = 'האימיל שלך כבר תפוס';
                      });
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    setState(() {
                      alert=true;
                      show_spinner = false;
                      _error_msg = 'error in the system';
                    });
                  }
                },
              ),
            ),

          ],
        );



  }
}


Map<String, Icon> user_types(List<Color> colors) => {

  "מנהל": Icon(Icons.admin_panel_settings_outlined, size: 25 ,color: colors[0]),
  "מבקש עזרה": Icon(Icons.account_circle_outlined, size: 25,color: colors[1]),
  "עוזר": Icon(Icons.supervisor_account_sharp, size: 25,color: colors[2] ),
 // "צד שלישי": Icon(Icons.app_registration, size: 27,color: colors[3] ),
};

bool Check_user(name, String id, String phone_number, String email, String pw, String second_pw){



}



class demo_bg extends StatelessWidget {
  Widget son;
  demo_bg(this.son);
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(

          color: Colors.transparent,
          child: new Container(
            padding: EdgeInsets.only(bottom: 50),
            decoration: new BoxDecoration(
                color: BasicColor.clr,
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(150),
                  bottomRight: const Radius.circular(150),
                )
            ),
            child: son,
          ),
        ),

      ],
    );
  }
}


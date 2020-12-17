import 'package:flutter/material.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadar/lang/HebrewText.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/validators.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';


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
  bool not_clicked = true;
  bool first_time = true;
  Privilege clicked_priv = null;
  Map<String, Icon> tripTypes = user_types([Colors.black , Colors.black , Colors.black]);
  List<String> tripKeys ;

  final name_Controller = TextEditingController();
  final id_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final first_pw_Controller = TextEditingController();
  final second_pw_Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    List<String> tripKeys = tripTypes.keys.toList();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Form(
                        child: Custom_Text_feild('שם מלא',Icon(Icons.account_circle_rounded ),Color(0xff494CF5),Colors.black,name_Validator.Validate,name_Controller,false),
                        key: nameKey,
                      ),
                      Form(
                        child: Custom_Text_feild('תעודת זהות',Icon(Icons.arrow_left_outlined),Color(0xff494CF5),Colors.black,Id_Validator.Validate,id_Controller,false),
                        key: idKey,
                      ),
                      Form(
                        child: Custom_Text_feild('מספר טלפון',Icon(Icons.phone),Color(0xff494CF5),Colors.black,number_Validator.Validate,phone_Controller,false),
                        key: phoneKey,
                      ),
                      Form(
                        child: Custom_Text_feild('כתובת אימיל',Icon(Icons.email),Color(0xff494CF5),Colors.black,Email_Validator.Validate,email_Controller,false),
                        key: emailKey,
                      ),
                      Form(
                        child: Custom_Text_feild('סיסמה',Icon(Icons.lock, size: 20),Color(0xff494CF5),Colors.black,password_Validator.Validate,first_pw_Controller,true),
                        key: paswwordKey,
                      ),
                      Form(
                        child: Custom_Text_feild('אימות סיסמה',Icon(Icons.lock),Color(0xff494CF5),Colors.black,second_pw_Validator.Validate,second_pw_Controller,true),
                        key: secnd_pass_Key,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(

                    'נרשם בתור:',
                    style: TextStyle(
                      fontSize: 20,

                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,

                  ),
                ),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    scrollDirection: Axis.vertical,
                    primary: false,
                    children: List.generate(tripTypes.length, (index) {
                      return FlatButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            tripTypes[tripKeys[index]],
                            Text(tripKeys[index]),
                          ],
                        ),
                        onPressed: ()  {
                          not_clicked = false;
                          if(index == 0){
                            clicked_priv = Privilege.Admin;
                          }
                          if(index == 1){
                            clicked_priv = Privilege.UserInNeed;
                          }
                          if(index == 2){
                            clicked_priv = Privilege.Volunteer;
                          }
//                          if(index == 3){
//                            clicked_priv = Privilege.Admin;
//                          }
                          setState(() {
                            tripTypes = update_list(index);
                          });
                        },
                      );
                    }),
                  ),


                ),

                Container(margin: EdgeInsets.all(20),child: showAlert()),
                Container(
                  margin: EdgeInsets.only(bottom: 60),
                  child: RaisedButton(
                    color: Color(0xff494CF5),
                    splashColor: Colors.white,
                    child: Text('הרשמה',style: TextStyle(fontSize: 18 , color: Colors.white),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {
                      second_pw_Validator.First_pw = first_pw_Controller.text;
                      if(first_time){
                        setState(() {
                          first_time=false;
                        });
                      }
                      if(!nameKey.currentState.validate() ||!idKey.currentState.validate() ||!phoneKey.currentState.validate()
                          ||!emailKey.currentState.validate() || !paswwordKey.currentState.validate()
                          ||!secnd_pass_Key.currentState.validate()
                      ){
                        return;
                      }
                      assert (clicked_priv != null);
                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email_Controller.text,
                            password: first_pw_Controller.text
                        );

                        addUserToDb(name_Controller.text, id_Controller.text, phone_Controller.text, email_Controller.text, clicked_priv);

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),

              ],
            ),
    );
  }

  Map<String, Icon> update_list(int index) {

    List<Color> new_clrs = [index == 0 ? Color(0xff494CF5) : Colors.grey ,
      index == 1 ? Color(0xff494CF5) : Colors.grey,
      index == 2 ? Color(0xff494CF5) : Colors.grey];
    return user_types(new_clrs);
  }

  Widget showAlert() {
    if (not_clicked && !first_time) {
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
                  first_time = false;
                },
              ),
            ),
            Expanded(
              child: Text(
                'אנא בחר את התור שלך',
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

}


Map<String, Icon> user_types(List<Color> colors) => {

  "מנהל": Icon(Icons.admin_panel_settings_outlined, size: 27 ,color: colors[0]),
  "מבקש עזרה": Icon(Icons.account_circle_outlined, size: 27,color: colors[1]),
  "עוזר": Icon(Icons.supervisor_account_sharp, size: 27,color: colors[2] ),
 // "צד שלישי": Icon(Icons.app_registration, size: 27,color: colors[3] ),
};

bool Check_user(name, String id, String phone_number, String email, String pw, String second_pw){



}


void addUserToDb(String name , String id,String phoneNumber,String email,Privilege privilege){

  switch (privilege){
    case Privilege.UserInNeed :
      DataBaseService().addUserInNeedToDataBase(UserInNeed(name, phoneNumber, email, false, id));
      break;
    case Privilege.Admin:
      DataBaseService().addAdminToDataBase(Admin(name, phoneNumber, email, false, id));
      break;
      //TODO UPDATE CATOEGOREIS
    case Privilege.Volunteer:
      DataBaseService().addVolunteerToDataBase(Volunteer(name, phoneNumber, email, false, id, []));
      break;
    case Privilege.UnregisterUser:
      print('error in unregiesterd user in regienstaron');
      break;
    default:
      print('error in reg page');
  }

}
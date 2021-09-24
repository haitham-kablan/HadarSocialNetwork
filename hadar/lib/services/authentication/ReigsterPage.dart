import 'package:flutter/gestures.dart';
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
import 'package:hadar/users/Organization.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/VerificationRequest.dart';
import 'package:intl/intl.dart';

import 'forms/UserInNeedRegPage.dart';
import 'forms/VolunteerRegPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool isChecked = false;
  String _error_msg = '';
  bool alert = false;
  bool clicked=false;
  Privilege clicked_priv = null;
  Map<String, Icon> tripTypes = user_types([Colors.grey , Colors.grey , Colors.grey, Colors.grey]);
  List<String> tripKeys ;
  TextStyle linkStyle = TextStyle(color: BasicColor.clr , fontSize: 15 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline);
  final name_Controller = TextEditingController();
  final id_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final first_pw_Controller = TextEditingController();
  final second_pw_Controller = TextEditingController();
  bool show_spinner = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> tripKeys = tripTypes.keys.toList();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: get_bg(size),
        ),
    );
  }

  Map<String, Icon> update_list(int index) {

    List<Color> new_clrs = [index == 0 ? BasicColor.clr : Colors.grey ,
      index == 1 ? BasicColor.clr : Colors.grey,
      index == 2 ? BasicColor.clr : Colors.grey,
      index == 3 ? BasicColor.clr : Colors.grey];
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
  Widget get_bg(Size size){
    return  Column(
          children: [
            demo_bg(
              Column(
                children: [
                  SizedBox(height: 60),
                  Container(child: showAlert_as_col()),
                  Form(
                    child: Custom_Text_feild(AppLocalizations.of(context).fullName, Icon(Icons.account_circle_rounded,color: Colors.white ),Colors.white,Colors.white,name_Validator.Validate,name_Controller,false,Colors.white),
                    key: nameKey,
                  ),
                  Form(
                    child: Custom_Text_feild(AppLocalizations.of(context).id, Icon(Icons.arrow_left_outlined,color: Colors.white),Colors.white,Colors.white,Id_Validator.Validate,id_Controller,false,Colors.white, allowWhiteSpaces: false,),
                    key: idKey,
                  ),
                  Form(
                    child: Custom_Text_feild(AppLocalizations.of(context).telNumber, Icon(Icons.phone,color: Colors.white),Colors.white,Colors.white,number_Validator.Validate,phone_Controller,false,Colors.white, allowWhiteSpaces: false,),
                    key: phoneKey,
                  ),
                  Form(
                    child: Custom_Text_feild(AppLocalizations.of(context).emailAddress, Icon(Icons.email,color: Colors.white),Colors.white,Colors.white,Email_Validator.Validate,email_Controller,false,Colors.white, allowWhiteSpaces: false,),
                    key: emailKey,
                  ),
                  Form(
                    child: Custom_Text_feild(AppLocalizations.of(context).password, Icon(Icons.lock, color: Colors.white),Colors.white,Colors.white,password_Validator.Validate,first_pw_Controller,true,Colors.white),
                    key: paswwordKey,
                  ),
                  Form(
                    child: Custom_Text_feild(AppLocalizations.of(context).confirmPassword, Icon(Icons.lock,color: Colors.white),Colors.white,Colors.white,second_pw_Validator.Validate,second_pw_Controller,true,Colors.white),
                    key: secnd_pass_Key,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:30),
              child: Text(
                AppLocalizations.of(context).signedAs,
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
                        clicked_priv = Privilege.Admin;
                      });
                    },
                    child: Column(
                      children: [
                        tripTypes["מנהל"],
                        Text(AppLocalizations.of(context).admin),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        tripTypes = update_list(1);
                        alert = false;
                        clicked=true;
                        clicked_priv = Privilege.UserInNeed;
                      });
                    },
                    child: Column(
                      children: [
                        tripTypes["מבקש עזרה"],
                        Text(AppLocalizations.of(context).userInNeed),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        tripTypes = update_list(2);
                        alert = false;
                        clicked=true;
                        clicked_priv = Privilege.Volunteer;
                      });
                    },
                    child: Column(
                      children: [
                        tripTypes["עוזר"],
                        Text(AppLocalizations.of(context).volunteer),
                      ],
                    ),
                  ),
                  // FlatButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       tripTypes = update_list(3);
                  //       alert = false;
                  //       clicked=true;
                  //       clicked_priv = Privilege.Organization;
                  //     });
                  //   },
                  //   child: Column(
                  //     children: [
                  //       tripTypes["עמותה"],
                  //       Text('עמותה'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),

            SizedBox(height: 20,),
            Row(
              children: [
                Spacer(flex: 1,),
                Checkbox(value: isChecked, onChanged: (bool value) { setState(() {
                  isChecked = value;
                }); },
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[

                      TextSpan(
                          text: AppLocalizations.of(context).terms,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(context: context, builder: (context){
                                return Center(
                                  child: Container(
                                    height: size.height * 0.7,
                                    width: size.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: BasicColor.backgroundClr,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 30,),
                                          Material(
                                            color: Colors.transparent,
                                              child: Text("תנאי השישמוש של האפליקציה",style: TextStyle(color: BasicColor.clr,fontSize: 20),)),
                                          SizedBox(height: 25,),
                                          Material(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text("1. אני מודע\\ת ומסכים\\מה כי בקשת העזרה שלי מפורסמת בפומבי ומנוהלת על ידי עובדות סוציאליות המתחזקות את האפליקציה המכונה \"רשת חברתית\" ",style: TextStyle(color: Colors.grey[800],fontSize: 15),),
                                              )),
                                          SizedBox(height: 20,),
                                          Material(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text("2. אני מודע\\ת ומסכים\\מה כי האפליקציה מנטרת את המיקו שלי , המיקום חשוף רק לעובדות הסוציאליות המנווטות את המידע ולצוות ניהול הנתונים הטכניוני ולא לכלל הציבור.",style: TextStyle(color: Colors.grey[800],fontSize: 15),),
                                              )),
                                          SizedBox(height: 20,),
                                          Material(
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text("3. אני מודע\\ת ומסכים\\מה כי תיעוד הבקשות נשמר במחשבי הטכניון התומכים בפלטפורמה במטרה לשפר את רווחת התושבים בשכונת הדר ולתמוך במחקר התומך.",style: TextStyle(color: Colors.grey[800],fontSize: 15),),
                                              )),
                                          //SizedBox(height: 20,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }),
                    ],
                  ),
                ),

                Spacer(flex: 1,),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.all(10),
              child: show_spinner ? SpinKitCircle(color: BasicColor.clr,) :RaisedButton(
                color: BasicColor.clr,
                splashColor: Colors.white,
                child: Text(AppLocalizations.of(context).register,style: TextStyle(fontSize: 18 , color: Colors.white),),
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
                      _error_msg = AppLocalizations.of(context).idAlreadyTaken;

                    });
                    return;
                  }
                  if(clicked == false){
                    setState(() {
                      alert=true;
                      show_spinner = false;
                      _error_msg = AppLocalizations.of(context).chooseUrPrevilge;

                    });
                    return;
                  }

                  if(!isChecked){
                    setState(() {
                      alert=true;
                      show_spinner = false;
                      _error_msg = "נא אשר את תנאי השימוש באפליקציה";

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
                    Organization organization;
                    int lastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
                    switch(clicked_priv){
                      case Privilege.UserInNeed:
                        user_in_need = UserInNeed(Privilege.UserInNeed , name_Controller.text, phone_Controller.text, email_Controller.text, id_Controller.text,lastNotifiedTime, 0,'','',0,'','','','');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => userInNeedRegisterPage(user_in_need)));
                        break;
                      case Privilege.Admin:
                        DataBaseService().addVerficationRequestToDb(VerificationRequest(UnregisteredUser(name_Controller.text, phone_Controller.text, email_Controller.text, id_Controller.text),  clicked_priv, DateTime.now(),"","","","","","","","",List<HelpRequestType>()));
                        Navigator.pop(context);
                        break;
                      case Privilege.Volunteer:
                        volunteer = Volunteer(name_Controller.text, phone_Controller.text, email_Controller.text, id_Controller.text, lastNotifiedTime,'',0,'','','','','','','','',[]);

                        Navigator.push(context, MaterialPageRoute(builder: (context) => volunteerRegisterPage(volunteer)));
                        break;
                      // case Privilege.Organization:
                      //   String location = "מזרח הדר";
                      //   List<HelpRequestType> services = [
                      //     HelpRequestType("תרופות"),
                      //     HelpRequestType("טיפול שיניים"),
                      //   ];
                      //   organization = Organization(name_Controller.text, phone_Controller.text, email_Controller.text, false, id_Controller.text,location,services);
                      //   //in the mean time, for testing purposes, add the organization directly to the database
                      //   //the following line should be removed later
                      //   DataBaseService().addOrganizationToDataBase(organization);
                      //   //todo: implement OrganizationRegisterPage and navigate to it
                      //   //Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizationRegisterPage(organization)));
                      //   Navigator.pop(context);
                      //   break;
                      default:
                        Navigator.pop(context);
                        break;
                    }


                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      setState(() {
                        alert=true;
                        show_spinner = false;
                        _error_msg = AppLocalizations.of(context).passwordIsTooWeak;
                      });
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        alert=true;
                        show_spinner = false;
                        _error_msg = AppLocalizations.of(context).emailIsAlreadyTaken;
                      });
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    setState(() {
                      alert=true;
                      show_spinner = false;
                      _error_msg = AppLocalizations.of(context).systemError;
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
  "עמותה": Icon(Icons.house_siding_sharp, size: 25,color: colors[3] ),
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


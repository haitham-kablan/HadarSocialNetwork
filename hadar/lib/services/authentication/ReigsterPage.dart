import 'package:flutter/material.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hadar/services/authentication/validators.dart';


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
  Map<String, Icon> tripTypes = user_types([Colors.black , Colors.black , Colors.black , Colors.black]);
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
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Form(
                    child: Custom_Text_feild('שם מלא',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange,name_Validator.Validate,name_Controller,false),
                    key: nameKey,
                  ),
                  Form(
                    child: Custom_Text_feild('תעודת זהות',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange,Id_Validator.Validate,id_Controller,false),
                    key: idKey,
                  ),
                  Form(
                    child: Custom_Text_feild('מספר טלפון',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange,number_Validator.Validate,phone_Controller,false),
                    key: phoneKey,
                  ),
                  Form(
                    child: Custom_Text_feild('כתובת אימיל',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange,Email_Validator.Validate,email_Controller,false),
                    key: emailKey,
                  ),
                  Form(
                    child: Custom_Text_feild('סיסמה',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange,password_Validator.Validate,first_pw_Controller,true),
                    key: paswwordKey,
                  ),
                  Form(
                    child: Custom_Text_feild('אימות סיסמה',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange,second_pw_Validator.Validate,second_pw_Controller,true),
                    key: secnd_pass_Key,
                  ),
                ],
              ),
            ),
            Text(
              'נרשם בתור:',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
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
                      setState(() {
                        tripTypes = update_list(index);
                      });
                    },
                  );
                }),
              ),
            ),

            RaisedButton(
              onPressed: () async {
                second_pw_Validator.First_pw = first_pw_Controller.text;

                if(!nameKey.currentState.validate() ||!idKey.currentState.validate() ||!phoneKey.currentState.validate()
                    ||!emailKey.currentState.validate() || !paswwordKey.currentState.validate()
                    ||!secnd_pass_Key.currentState.validate()
                ){
                  return;
                }

                try {
                 await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email_Controller.text,
                      password: first_pw_Controller.text

                  );
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
              child: Text('הרשמה'),
            ),

          ],
        ),

    );
  }

  Map<String, Icon> update_list(int index) {

    List<Color> new_clrs = [index == 0 ? Colors.blue : Colors.black ,
      index == 1 ? Colors.blue : Colors.black,
      index == 2 ? Colors.blue : Colors.black,
      index == 3 ? Colors.blue : Colors.black];
    return user_types(new_clrs);
  }

}


Map<String, Icon> user_types(List<Color> colors) => {

  "מנהל": Icon(Icons.admin_panel_settings_outlined, size: 30 ,color: colors[0]),
  "מבקש עזרה": Icon(Icons.directions_bus, size: 30,color: colors[1]),
  "עוזר": Icon(Icons.train, size: 30,color: colors[2] ),
  "צד שלישי": Icon(Icons.airplanemode_active, size: 30,color: colors[3] ),
};

bool Check_user(name, String id, String phone_number, String email, String pw, String second_pw){



}



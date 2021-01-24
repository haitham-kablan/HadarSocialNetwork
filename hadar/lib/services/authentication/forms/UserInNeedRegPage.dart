import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/UserInNeed.dart';

class userInNeedRegisterPage extends StatefulWidget {
  final UserInNeed user;
  userInNeedRegisterPage(this.user);
  @override
  _userInNeedRegisterPageState createState() =>
      _userInNeedRegisterPageState(this.user);
}

class _userInNeedRegisterPageState extends State<userInNeedRegisterPage> {
  final age = GlobalKey<FormState>();
  final location = GlobalKey<FormState>();
  final status = GlobalKey<FormState>();
  final eduStatus = GlobalKey<FormState>();
  final numKids = GlobalKey<FormState>();
  final homephone = GlobalKey<FormState>();
  final specialstatus = GlobalKey<FormState>();
  final rev7a = GlobalKey<FormState>();
  final UserInNeed user;
  _userInNeedRegisterPageState(this.user);

  final age_controller = TextEditingController();
  final location_controller = TextEditingController();
  final status_controller = TextEditingController();
  final eduStatus_controller = TextEditingController();
  final numKids_controller = TextEditingController();
  final homephone_controller = TextEditingController();
  final specialstatus_controller = TextEditingController();
  final rev7a_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.rtl,
        child: new Builder(builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Center(child: get_bg()),
          );
        }));
  }

  Widget get_bg() {
    return new Scaffold(
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  demo_bg(Column(children: [
                    SizedBox(height: 60),
                    Form(
                      child: Custom_Text_feild(
                          'גיל',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          age_controller,
                          false,
                          Colors.white),
                      key: age,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'כתובת',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          location_controller,
                          false,
                          Colors.white),
                      key: location,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'מצב משפחתי',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          status_controller,
                          false,
                          Colors.white),
                      key: status,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'מספר ילדים',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          numKids_controller,
                          false,
                          Colors.white),
                      key: numKids,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'מסדרת חינוך (במידה ורלוונטי)',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          eduStatus_controller,
                          false,
                          Colors.white),
                      key: eduStatus,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'מספר טלפון בית (במידה ויש)',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          homephone_controller,
                          false,
                          Colors.white),
                      key: homephone,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'ותיק/ערבי/עולה חדש?',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          specialstatus_controller,
                          false,
                          Colors.white),
                      key: specialstatus,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'מטופל ברווחה',
                          null,
                          Colors.white,
                          Colors.white,
                          null,
                          rev7a_controller,
                          false,
                          Colors.white),
                      key: rev7a,
                    ),
                  ])),
                  new Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: new RaisedButton(
                          color: BasicColor.clr,
                          splashColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text(
                            'הגש',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: (){

                          user.Age = age_controller.text == '' ? 0 : int.parse(age_controller.text);
                          user.homePhone = homephone_controller.text;
                          user.numKids = age_controller.text == '' ? 0 :int.parse(numKids_controller.text);
                          user.eduStatus = eduStatus_controller.text;
                          user.Status = status_controller.text;
                          user.Location = location_controller.text;
                          user.specialStatus = specialstatus_controller.text;
                          user.Rav7a = rev7a_controller.text;
                          DataBaseService().addUserInNeedToDataBase(user);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          },
                        ),
                      )),
                ],
              ))),
    );
  }
}

class demo_bg extends StatelessWidget {
  Widget son;
  demo_bg(this.son);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: new Container(
            padding: EdgeInsets.only(bottom: 100),
            decoration: new BoxDecoration(
                color: BasicColor.clr,
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(150),
                  bottomRight: const Radius.circular(150),
                )),
            child: son,
          ),
        ),
      ],
    );
  }
}

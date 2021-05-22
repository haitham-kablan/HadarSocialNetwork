import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/VerificationRequest.dart';

import '../../DataBaseServices.dart';

class volunteerRegisterPage extends StatefulWidget {
  final Volunteer user;
  volunteerRegisterPage(this.user);
  @override
  _volunteerRegisterPageState createState() =>
      _volunteerRegisterPageState(this.user);
}

class _volunteerRegisterPageState extends State<volunteerRegisterPage> {
  final birthdate = GlobalKey<FormState>();
  final location = GlobalKey<FormState>();
  final status = GlobalKey<FormState>();
  final work = GlobalKey<FormState>();
  final birthplace = GlobalKey<FormState>();
  final spokenlangs = GlobalKey<FormState>();

  final mobility = GlobalKey<FormState>();
  final firstaidcourse = GlobalKey<FormState>();

  final Volunteer user;
  _volunteerRegisterPageState(this.user);

  final birthdate_controller = TextEditingController();
  final location_controller = TextEditingController();
  final status_controller = TextEditingController();
  final work_controller = TextEditingController();
  final birthplace_controller = TextEditingController();
  final spokenlangs_controller = TextEditingController();

  final mobility_controller = TextEditingController();
  final firstaidcourse_controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.rtl,
        child: new Builder(builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
                          'תאריך לידה',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          Colors.white,
                          Colors.white,
                          null,
                          birthdate_controller,
                          false,
                          Colors.white),
                      key: birthdate,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'כתובת',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
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
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
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
                          'עיסוק',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          Colors.white,
                          Colors.white,
                          null,
                          work_controller,
                          false,
                          Colors.white),
                      key: work,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'ארץ לידה',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          Colors.white,
                          Colors.white,
                          null,
                          birthplace_controller,
                          false,
                          Colors.white),
                      key: birthplace,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'שפות מדוברות',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          Colors.white,
                          Colors.white,
                          null,
                          spokenlangs_controller,
                          false,
                          Colors.white),
                      key: spokenlangs,
                    ),

                    Form(
                      child: Custom_Text_feild(
                          'ניידות',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          Colors.white,
                          Colors.white,
                          null,
                          mobility_controller,
                          false,
                          Colors.white),
                      key: mobility,
                    ),
                    Form(
                      child: Custom_Text_feild(
                          'בעל קורס עזרה ראשונה?',
                          Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          Colors.white,
                          Colors.white,
                          null,
                          firstaidcourse_controller,
                          false,
                          Colors.white),
                      key: firstaidcourse,
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
                          onPressed: () {
                            user.firstaidcourse = firstaidcourse_controller.text;
                            user.mobility = mobility_controller.text;
                            user.spokenlangs = spokenlangs_controller.text;
                            user.location = location_controller.text;
                            user.birthdate = birthdate_controller.text;
                            user.birthplace = birthplace_controller.text;
                            user.status = status_controller.text;
                            user.work = work_controller.text;
                            UnregisteredUser sender = UnregisteredUser(user.name, user.phoneNumber, user.email, user.id);

                            DataBaseService().addVerficationRequestToDb(VerificationRequest(sender, Privilege.Volunteer, DateTime.now()
                            ,user.birthdate , user.location , user.status , user.work , user.birthplace , user.spokenlangs , user.mobility ,user.firstaidcourse,List<HelpRequestType>()));
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

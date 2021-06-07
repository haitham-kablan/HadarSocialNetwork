import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/descriptionBox.dart';

import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/services/DataBaseServices.dart';

import '../Design/mainDesign.dart';
import '../profiles/adminProfile.dart';
import '../profiles/profileItems/validators.dart';
import '../users/Privilege.dart';

class AddOrganizationWindow extends StatefulWidget {
  @override
  _AddOrganizationWindowState createState() => _AddOrganizationWindowState();
}

class _AddOrganizationWindowState extends State<AddOrganizationWindow> {
  final orgNameKey = GlobalKey<FormState>();
  final orgPhoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final locationKey = GlobalKey<FormState>();

  // List<HelpRequestType> types;
  String _error_msg = '';
  bool alert = false;
  bool clicked = false;
  Privilege clicked_priv = null;
  final name_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final location_Controller = TextEditingController();

  Widget getRelContainer(Form form) {
    return Container(

      height: 100,
      child: form,
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
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
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
              child: Icon(Icons.error_outline, color: Colors.white),
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
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 150, title: 'הוספת עמותה'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Container(child: showAlert_as_col()),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'שם עמותה',
                            Icon(Icons.account_circle_rounded,
                                color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidateName,
                            name_Controller,
                            false,
                            Colors.white),
                        key: orgNameKey,
                      ),
                    ),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'מספר טלפון',
                            Icon(Icons.phone, color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidatePhone,
                            phone_Controller,
                            false,
                            Colors.white),
                        key: orgPhoneKey,
                      ),
                    ),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'כתובת אלקטרונית',
                            Icon(Icons.email, color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidateEmail,
                            email_Controller,
                            false,
                            Colors.white),
                        key: emailKey,
                      ),
                    ),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'כתובת',
                            Icon(Icons.location_on, color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidateLocation,
                            location_Controller,
                            false,
                            Colors.white),
                        key: locationKey,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        //TODO:add services
                        //TODO:add to the database
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminProfile()),
                        );
                      },
                      // style: TextButton.styleFrom(
                      //   primary: Theme.of(context).primaryColor,
                      // ),
                      child: Text('אישור'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class AdminAddOrganizationWindow extends StatelessWidget {
//   final orgName = GlobalKey<FormState>();
//   final orgPhone = GlobalKey<FormState>();
//   final email = GlobalKey<FormState>();
//   final locationDescription = GlobalKey<FormState>();
//
//   // List<HelpRequestType> types;
//   String _error_msg = '';
//   bool alert = false;
//   bool clicked = false;
//   Privilege clicked_priv = null;
//
//   // HelpRequestType helpRequestType;
//
//   AdminAddOrganizationWindow() {
//     this.desName = DescriptonBox(title: 'שם');
//     this.desPhone = DescriptonBox(title: 'מספר טלפון');
//     this.desEmail = DescriptonBox(title: 'כתובת אלקטרונית');
//     this.desLocation = DescriptonBox(title: 'מיקום');
//   }
//
//   Widget getRelContainer(DescriptonBox des) {
//     return Container(
//       height: 100,
//       child: des,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         bottomNavigationBar: AdminBottomBar(),
//         body: CustomScrollView(
//           slivers: [
//             SliverPersistentHeader(
//               delegate:
//                   MySliverAppBar(expandedHeight: 150, title: 'הוספת עמותה'),
//               pinned: true,
//             ),
//             SliverFillRemaining(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 100,
//                     ),
//                     getRelContainer(desPhone),
//                     getRelContainer(desEmail),
//                     getRelContainer(desLocation),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     RaisedButton(
//                       onPressed: () async {
//                         orgName = desName.getDataEntered();
//                         orgPhone = desPhone.getDataEntered();
//                         email = desEmail.getDataEntered();
//                         locationDescription = desLocation.getDataEntered();
//                         DescriptonBox(title: 'תיאור בקשה');
//                         //TODO:add services
//                         //TODO:add to the database
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AdminProfile()),
//                         );
//                       },
//                       child: Text('אישור'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

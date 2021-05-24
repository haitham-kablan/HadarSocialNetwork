// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hadar/services/DataBaseServices.dart';
// import 'package:hadar/services/authentication/LogInPage.dart';
// import 'package:hadar/userInquiryView.dart';
// import 'package:hadar/users/CurrentUser.dart';
// import 'package:hadar/users/User.dart' as a;
// import 'package:hadar/users/User.dart';
// import 'package:hadar/utils/HelpRequestType.dart';
// import '../Design/basicTools.dart';
// import '../Design/mainDesign.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// import '../adminAddHelpRequest.dart';
//
//
// //when a user clicks on the category, he gets a description box,
// // where he can describe his request
// class DescriptonBox extends StatefulWidget {
//   DescriptonBox({Key key, this.title}) : super(key: key);
//   _DescriptonBox desBoxState = _DescriptonBox();
//   final String title;
//
//
//   void processText() {
//     desBoxState.processText();
//   }
//
//   @override
//   _DescriptonBox createState() => desBoxState;
// }
//
// class _DescriptonBox extends State<DescriptonBox> {
//   String _inputtext = 'waiting..';
//   TextEditingController inputtextField = TextEditingController();
//
//   void processText() {
//     setState(() {
//       _inputtext = inputtextField.text;
//       HelpRequestType helpRequestType= HelpRequestType(_inputtext);
//       _inputtext=null;
//       DataBaseService().addHelpRequestTypeDataBase(helpRequestType);
//       Navigator.of(context).pop();
//     }
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(height: 110,
//
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: TextField(
//                       controller: inputtextField,
//                       textAlign: TextAlign.right,
//                       autofocus: true,
//                       decoration: new InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: widget.title,
//                       ),
//                     ))),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AdminProfile extends StatelessWidget {
//   a.User user=CurrentUser.curr_user;
//   DescriptonBox desBox;
//
//   Widget addCategory(BuildContext context) {
//     return new AlertDialog( backgroundColor: BasicColor.backgroundClr,
//       title: Center(child: const Text('הוספת קטיגוריה')),
//       content:desBox,
//       actions: <Widget>[
//         new FlatButton(
//           onPressed: () {
//             desBox.processText();
//           },
//           textColor: Theme.of(context).primaryColor,
//           child: const Text('אישור'),
//         ),
//       ],
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Admin Profile',
//       home: Scaffold(
//         // resizeToAvoidBottomInset: false,
//         bottomNavigationBar: AdminBottomBar(),
//         backgroundColor: BasicColor.backgroundClr,
//         body: CustomScrollView(
//           slivers: [
//             SliverPersistentHeader(
//               delegate: MySliverAppBar(expandedHeight: 150, title: user.name),
//               pinned: true,
//             ),
//             SliverFillRemaining(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 120,
//                     ),
//                     Text(
//                       user.name,
//                       style: TextStyle(
//                           fontSize: 25.0,
//                           color: Colors.blueGrey,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "Admin" ,
//                       style: TextStyle(
//                           fontSize: 18.0,
//                           color: Colors.black45,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w300),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Text(
//                       user.phoneNumber+'  :' + 'מספר טלפון',
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.blueGrey,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       height:20,
//                     ),
//                     Text(
//                       user.email +'  :' + 'אימיל',
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.blueGrey,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//
//                     SizedBox(
//                       height:40,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Column(
//                           children: [
//                             SizedBox(
//                               height: 7,
//                             ),
//                             RaisedButton(
//                               onPressed: () {
//                                 desBox = DescriptonBox();
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) => addCategory(context),
//                                 );
//                               },
//                               child: Text('הוספת קטיגוריה'),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             SizedBox(
//                               height: 7,
//                             ),
//                             RaisedButton(
//                               onPressed: () async {
//                                 List<HelpRequestType> types =
//                                 await DataBaseService().helpRequestTypesAsList();
//                                 types.add(HelpRequestType('אחר..'));
//                                 //we must add אחר so it always appears on the last of the list
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => AdminRequestWindow(this, types)),
//                                 );
//                               },
//                               child: Text('הוספת בקשה'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     FlatButton(
//                       child: Text(
//                         'יציאה',
//                         style: TextStyle(
//                             fontSize: 20.0,
//                             decoration: TextDecoration.underline,
//                             color: BasicColor.clr,
//                             letterSpacing: 2.0,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       onPressed:() {
//                         DataBaseService().Sign_out(context);
//                       },),
//
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Container(
//                       alignment: Alignment.bottomRight,
//                       child: FlatButton(
//                         child:
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             const Text(
//                               'פניות ממשתמשים',
//                               style: TextStyle(
//                                   fontSize: 20.0,
//                                   color: Colors.blueGrey,
//                                   letterSpacing: 2.0,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                             Icon(Icons.warning_rounded, color: Colors.red,),
//                           ],
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => userInquiryView(this)),
//                           );
//                         },
//                       ),
//                     ),
//                     FlatButton(
//                       child: Text(
//                         'הסר אותי מהמערכת',
//                         style: TextStyle(
//                             fontSize: 20.0,
//                             decoration: TextDecoration.underline,
//                             color: BasicColor.clr,
//                             letterSpacing: 2.0,
//                             fontWeight: FontWeight.w400),
//                       ),
//                       onPressed: () async {
//                         await DataBaseService().RemoveCurrentuserFromAuthentication();
//                         DataBaseService().RemoveUserfromdatabase(user);
//                         DataBaseService().Sign_out(context);
//                       },
//
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

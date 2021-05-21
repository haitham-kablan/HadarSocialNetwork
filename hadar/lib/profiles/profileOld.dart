// import 'dart:math';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hadar/services/DataBaseServices.dart';
// import 'package:hadar/services/authentication/LogInPage.dart';
// import 'package:hadar/users/Admin.dart';
// import 'package:hadar/users/CurrentUser.dart';
// import 'package:hadar/users/Privilege.dart';
// import 'package:hadar/users/User.dart' as a;
// import 'package:hadar/users/User.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'Design/basicTools.dart';
// import 'Design/mainDesign.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
//
// import 'TechSupportForm.dart';
//
//
// /*class ProfileBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       actionPane: SlidableDrawerActionPane(),
//       actionExtentRatio: 0.25,
//       child: Container(
//         color: Colors.transparent,
//         child: ListTile(
//           leading: CircleAvatar(
//             backgroundColor: Colors.green,
//             child: Text('On'),
//             foregroundColor: Colors.white,
//           ),
//           title: Text('סטטוס'),
//           subtitle: Text('מחובר'),
//         ),
//       ),
//       secondaryActions: <Widget>[
//         IconSlideAction(
//           caption: 'Logout',
//           color: Colors.blue,
//           icon: Icons.assignment_return,
//           onTap: () async {
//             await DataBaseService().Sign_out(context);
//           },
//         ),
//         IconSlideAction(
//           caption: 'Edit Profile',
//           color: BasicColor.clr,
//           icon: Icons.edit,
//           onTap: () {},
//         ),
//       ],
//     );
//   }
// }*/
//
//
// class ProfilePage extends StatelessWidget {
//   a.User user;
//   a.User adminAccess;
//   String privilege;
//
//   ProfilePage(a.User currUser) {
//     user = CurrentUser.curr_user;
//     switch (user.privilege) {
//       case Privilege.UserInNeed:
//         privilege = 'User in need';
//         break;
//       case Privilege.Volunteer:
//         privilege = 'Volunteer';
//         break;
//       case Privilege.Organization:
//         privilege = 'Organization';
//         break;
//       case Privilege.Admin:
//         privilege = 'Admin';
//         adminAccess = user;
//         user = currUser;
//         break;
//       default:
//         privilege = 'default';
//         break;
//     }
//   }
//
//   Widget removeUser(BuildContext context) {
//     return new AlertDialog(
//       backgroundColor: BasicColor.backgroundClr,
//       title: Center(child: const Text('למחוק המשתמש? ')),
//       actions: <Widget>[
//         new FlatButton(
//           onPressed: () {
//             //  TODO: remove this user
//           },
//           textColor: Theme.of(context).primaryColor,
//           child: const Text('אישור'),
//         ),
//       ],
//     );
//   }
//
//   Widget checkBottomBar() {
//     if (privilege == 'Admin') return AdminBottomBar();
//     return BottomBar();
//   }
//
//   Widget ifUserContactAdmin(BuildContext context){
//     if (privilege == 'Admin')
//       return SizedBox(width: 10,height:10);
//     else
//       return Container(
//         alignment: Alignment.topRight,
//         child: FlatButton(
//           child: Text(
//             'צור קשר',
//             style: TextStyle(
//                 fontSize: 20.0,
//                 color: Colors.blueGrey,
//                 letterSpacing: 2.0,
//                 fontWeight: FontWeight.w400),
//           ),
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) =>
//                   contactAdmin(context),
//             );
//           },
//         ),
//       );
//   }
//
//   Widget SignOutOrRemoveUser(BuildContext context) {
//     if (privilege == 'Admin')
//       return FlatButton(
//         child: Text(
//           'Remove this user',
//           style: TextStyle(
//               fontSize: 20.0,
//               decoration: TextDecoration.underline,
//               color: BasicColor.clr,
//               letterSpacing: 2.0,
//               fontWeight: FontWeight.w400),
//         ),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) => removeUser(context),
//           );
//         },
//
//       );
//     if (privilege != 'Admin') {
//       return Column(
//         children: [
//           FlatButton(
//             child: Text(
//               'יציאה',
//               style: TextStyle(
//                   fontSize: 20.0,
//                   decoration: TextDecoration.underline,
//                   color: BasicColor.clr,
//                   letterSpacing: 2.0,
//                   fontWeight: FontWeight.w400),
//             ),
//             onPressed: () {
//               DataBaseService().Sign_out(context);
//             },
//           ),
//
//           FlatButton(
//             child: Text(
//               'הסר אותי מהמערכת',
//               style: TextStyle(
//                   fontSize: 20.0,
//                   decoration: TextDecoration.underline,
//                   color: BasicColor.clr,
//                   letterSpacing: 2.0,
//                   fontWeight: FontWeight.w400),
//             ),
//             onPressed: () async {
//               await DataBaseService().RemoveCurrentuserFromAuthentication();
//               DataBaseService().RemoveUserfromdatabase(user);
//               DataBaseService().Sign_out(context);
//             },
//           ),
//
//         ],
//       );
//     }
//     else{
//       return SizedBox(
//         width: 20,
//         height: 20,
//
//       );
//       /* return FlatButton(
//       child: Text(
//         'Sign out',
//         style: TextStyle(
//             fontSize: 20.0,
//             decoration: TextDecoration.underline,
//             color: BasicColor.clr,
//             letterSpacing: 2.0,
//             fontWeight: FontWeight.w400),
//       ),
//       onPressed: () {
//         DataBaseService().Sign_out(context);
//       },
//     );*/
//     }}
//
//   _launchCaller() async {
//     String number;
//     // List<Admin> admins= await DataBaseService().getAllAdmins() as List<Admin>;
//     // Random rnd = new Random();
//     // Admin admin = admins[rnd.nextInt(admins.length)];
//     number = '0526736167';
//     var url = "tel:" + number;
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//
//   }
//
//
//   Widget contactAdmin(BuildContext context) {
//     return new AlertDialog(
//       backgroundColor: BasicColor.backgroundClr,
//       title: Center(child: const Text('יצירת קשר')),
//       actions: <Widget>[
//         Center(
//           child:
//           Column(
//             children: [
//               FlatButton(
//                 padding: EdgeInsets.only(right: 25.0),
//                 child: Row(
//                   children: [
//                     const Text('למלא טופס'),
//                     Icon(Icons.wysiwyg_rounded),
//                   ],
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => TechSupportForm(this)),
//                   );
//                 },
//                 textColor: Theme.of(context).primaryColor,
//               ),
//
//               FlatButton(
//                 padding: EdgeInsets.only(right: 15.0),
//                 child: Row(
//                   children: [
//                     const Text('להתקשר'),
//                     Icon(Icons.phone),
//                   ],
//                 ),
//                 onPressed: () {
//                   _launchCaller();
//                 },
//                 textColor: Theme.of(context).primaryColor,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Profile',
//       home: Scaffold(
//         bottomNavigationBar: checkBottomBar(),
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
//                       privilege,
//                       style: TextStyle(
//                           fontSize: 18.0,
//                           color: Colors.black45,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w300),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     // ProfileBanner(),
//                     // SizedBox(
//                     //   height: 30,
//                     // ),
//                     Card(
//                       margin:
//                       EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     "דירוג",
//                                     style: TextStyle(
//                                         color: Colors.blueAccent,
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   //ToDo add rank to database and user class
//                                   Text(
//                                     '20',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w300),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     "בקשות",
//                                     style: TextStyle(
//                                         color: Colors.blueAccent,
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   Text(
//                                     "1",
//                                     //Todo get the number of requests added by this user
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 22.0,
//                                         fontWeight: FontWeight.w300),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Text(
//                       user.phoneNumber + '  :' + 'מספר טלפון',
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.blueGrey,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       user.email + '  :' + 'אימיל',
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.blueGrey,
//                           letterSpacing: 2.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     SignOutOrRemoveUser(context),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     ifUserContactAdmin(context),
//                     // Container(
//                     //   alignment: Alignment.topRight,
//                     //   child: FlatButton(
//                     //     child: Text(
//                     //       'צור קשר',
//                     //       style: TextStyle(
//                     //           fontSize: 20.0,
//                     //           color: Colors.blueGrey,
//                     //           letterSpacing: 2.0,
//                     //           fontWeight: FontWeight.w400),
//                     //     ),
//                     //     onPressed: () {
//                     //       showDialog(
//                     //         context: context,
//                     //         builder: (BuildContext context) =>
//                     //             contactAdmin(context),
//                     //       );
//                     //     },
//                     //   ),
//                     // ),
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

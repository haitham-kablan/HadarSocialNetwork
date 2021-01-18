import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart' as a;
import 'package:hadar/users/User.dart';
import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProfileBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.transparent,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text('On'),
            foregroundColor: Colors.white,
          ),
          title: Text('סטטוס'),
          subtitle: Text('מחובר'),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Logout',
          color: Colors.blue,
          icon: Icons.assignment_return,
          onTap: () async {
            await DataBaseService().Sign_out(context);
          },
        ),
        IconSlideAction(
          caption: 'Edit Profile',
          color: BasicColor.clr,
          icon: Icons.edit,
          onTap: () {},
        ),
      ],
    );
  }
}


class ProfilePage extends StatelessWidget {
  a.User user;
  String privilege;

  ProfilePage() {
    user = CurrentUser.curr_user;
    switch(user.privilege){
      case Privilege.UserInNeed:
        privilege= 'User in need';
        break;
      case Privilege.Volunteer:
        privilege= 'Volunteer';
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: user.name),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      privilege ,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black45,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // ProfileBanner(),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("דירוג",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600
                                    ),),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  //ToDo add rank to database and user class
                                  Text('20',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w300
                                    ),)
                                ],
                              ),
                            ),
                            Expanded(
                              child:
                              Column(
                                children: [
                                  Text("בקשות",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600
                                    ),),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text("1",
                                    //Todo get the number of requests added by this user
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w300
                                    ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      user.phoneNumber+'  :' + 'מספר טלפון',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height:20,
                    ),
                    Text(
                      user.email +'  :' + 'אימיל',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height:40,
                    ),
                    FlatButton(
                      child: Text(
                        'Sign out',
                        style: TextStyle(
                            fontSize: 20.0,
                            decoration: TextDecoration.underline,
                            color: BasicColor.clr,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      ),
                    onPressed:() {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,MaterialPageRoute(
                          builder: (context) =>LogInPage()) );
                    },),

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

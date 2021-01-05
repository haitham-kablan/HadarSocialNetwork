import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadar/feeds/Admin_JoinRequest_Feed.dart';
import 'package:hadar/users/Admin.dart';

class AdminPage extends StatelessWidget {

  final Admin curr_user;
  AdminPage(this.curr_user);

  @override
  Widget build(BuildContext context) {
    return AdminJoinRequestsFeed(admin: curr_user,);
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Admin page'),
        centerTitle: true,
      ),
      body: AdminJoinRequestsFeed(admin: curr_user,),
      /*body: Container(
        child: Center(
          child: Column(
              children: [
                Icon(Icons.admin_panel_settings_outlined , size: 40,),
                RaisedButton(
                  child: Text('sign out'),
                  onPressed: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                ),
              ],
          ),
        ),
      ),*/
    );*/
  }
}

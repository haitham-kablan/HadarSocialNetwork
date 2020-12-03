

import 'package:hadar/users/RegisteredUser.dart';
import 'package:hadar/users/User.dart';

import 'UnregisteredUser.dart';

class Admin extends RegisteredUser{
  List users;

  Admin(String name, String phoneNumber, String email, bool isSignedIn , String id)
      : super(name, phoneNumber, email, Privilege.Admin, isSignedIn,id) {

    users = new List<RegisteredUser>();
  }

  void verifyUser(UnregisteredUser user){}  //todo: implement this
  void addNewHelpRequestType(){}  //todo: implement this
}
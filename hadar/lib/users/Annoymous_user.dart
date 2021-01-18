import 'package:hadar/users/RegisteredUser.dart';
import 'package:hadar/users/User.dart';

import 'UnregisteredUser.dart';

class Annoymous_user extends RegisteredUser{


  Annoymous_user(String name, String phoneNumber, String email, bool isSignedIn , String id)
      : super(name, phoneNumber, 'None', Privilege.Annoymous, false,id) {

  }


}
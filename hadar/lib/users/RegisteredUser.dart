
import 'package:hadar/users/User.dart';

import 'Privilege.dart';

abstract class RegisteredUser extends User{
  bool isSignedIn;

  RegisteredUser(String name, String phoneNumber, String email, Privilege privilege, bool isSignedIn , String id)
    : isSignedIn = isSignedIn, super(name, phoneNumber, email, privilege,id);
}

import 'package:hadar/users/User.dart';

abstract class RegisteredUser extends User{
  bool isSignedIn;

  RegisteredUser(String name, String phoneNumber, String email, Privilege privilege, bool isSignedIn)
    : isSignedIn = isSignedIn, super(name, phoneNumber, email, privilege);
}
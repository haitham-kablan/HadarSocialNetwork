
import 'package:hadar/users/User.dart';

abstract class RegisteredUser extends User{

  RegisteredUser(String name, String phoneNumber, String email, Privilege privilege)
    : super(name, phoneNumber, email, privilege);
}
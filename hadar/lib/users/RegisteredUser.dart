
import 'package:hadar/users/User.dart';

import 'Privilege.dart';

abstract class RegisteredUser extends User{

  RegisteredUser(String name, String phoneNumber, String email, Privilege privilege, String id, int lastNotifiedTime)
    : super(name, phoneNumber, email, privilege, id, lastNotifiedTime: lastNotifiedTime);
}
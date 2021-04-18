
import 'Privilege.dart';
import 'User.dart';

class UnregisteredUser extends User{

  UnregisteredUser(String name, String phoneNumber, String email,String id)
      : super(name, phoneNumber, email, Privilege.UnregisterUser,id);
}
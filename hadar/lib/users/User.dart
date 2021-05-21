


import 'Privilege.dart';

class User{
  String name;
  String phoneNumber;
  String email;
  String id;
  Privilege privilege;
  int lastNotifiedTime;

  User(this.name, this.phoneNumber, this.email, this.privilege , this.id, {this.lastNotifiedTime = 0});
}


import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart';

class VerificationRequest{
  UnregisteredUser sender;
  Privilege type;
  DateTime date;
  bool accepted;
  int time;

  VerificationRequest(this.sender, this.type, this.date ){
    accepted = false;
    time = date.millisecondsSinceEpoch;
  }
}
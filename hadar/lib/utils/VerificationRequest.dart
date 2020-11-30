
import 'package:hadar/users/UnregisteredUser.dart';

class VerificationRequest{
  UnregisteredUser sender;
  String type; // "Volunteer" or "UserInNeed"
  DateTime date;

  VerificationRequest(this.sender, this.type, this.date);
}
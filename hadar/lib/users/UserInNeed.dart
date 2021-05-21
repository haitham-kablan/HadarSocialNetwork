
import 'package:hadar/utils/HelpRequest.dart';

import 'Privilege.dart';
import 'RegisteredUser.dart';

class UserInNeed extends RegisteredUser{

  int Age;
  String Location;
  String Status;
  int numKids;
  String eduStatus;
  String homePhone;
  String specialStatus;
  String Rav7a;
  UserInNeed(Privilege privilege , String name, String phoneNumber, String email, bool isSignedIn , String id,int Age , String Location, String Status, int numKids,
      String eduStatus, String homePhone, String specialStatus, String Rav7a)
      : super(name, phoneNumber, email, privilege, isSignedIn , id){
    this.Age = Age;
    this.Location = Location;
    this.Status = Status;
    this.numKids = numKids;
    this.eduStatus = eduStatus;
    this.homePhone = homePhone;
    this.specialStatus = specialStatus;
    this.Rav7a = Rav7a;

  }


  void addHelpRequest(HelpRequest req){}   //todo: implement this
  void acceptOffer(){}   //todo: implement this
  void renewRequest(HelpRequest req){}   //todo: implement this

}
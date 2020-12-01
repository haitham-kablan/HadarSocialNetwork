
import 'package:hadar/users/User.dart';
import 'package:hadar/utils/HelpRequest.dart';

import 'RegisteredUser.dart';

class UserInNeed extends RegisteredUser{
  List myHelpRequests;

  UserInNeed(String name, String phoneNumber, String email, bool isSignedIn)
      : super(name, phoneNumber, email, Privilege.UserInNeed, isSignedIn){

    myHelpRequests = new List<HelpRequest>();
  }


  void addHelpRequest(HelpRequest req){}   //todo: implement this
  void acceptOffer(){}   //todo: implement this
  void renewRequest(HelpRequest req){}   //todo: implement this

}
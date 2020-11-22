
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'RegisteredUser.dart';
import 'User.dart';

class Volunteer extends RegisteredUser{
  List helpRequestsCategories;
  List helpRequests;

  Volunteer(String name, String phoneNumber, String email)
      : super(name, phoneNumber, email, Privilege.Volunteer){

    helpRequestsCategories = new List<HelpRequestType>();
    helpRequests = new List<HelpRequest>();
  }

  void addOffer(){} //todo: implement this
}
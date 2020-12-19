
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'RegisteredUser.dart';
import 'User.dart';

class Volunteer extends RegisteredUser{
  List<HelpRequestType> helpRequestsCategories;
  List helpRequests;

  Volunteer(String name, String phoneNumber, String email, bool isSignedIn , String id , List<HelpRequestType> categories)
      : super(name, phoneNumber, email, Privilege.Volunteer, isSignedIn , id){

    helpRequestsCategories = categories;
    helpRequests = new List<HelpRequest>();
  }

  void addOffer(){} //todo: implement this
}
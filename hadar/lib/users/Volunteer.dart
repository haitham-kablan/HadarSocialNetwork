
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
  int count;
  String stars;

  Volunteer(String name, String phoneNumber, String email, bool isSignedIn , String id , List<HelpRequestType> categories, String stars , int count)
      : super(name, phoneNumber, email, Privilege.Volunteer, isSignedIn , id){

    helpRequestsCategories = categories;
    helpRequests = new List<HelpRequest>();
    this.count  = count;
    this.stars = stars;
  }



  void addOffer(){} //todo: implement this
}

import 'dart:core';


import 'package:hadar/utils/HelpRequest.dart';

import 'Privilege.dart';
import 'RegisteredUser.dart';

class Volunteer extends RegisteredUser{
  List helpRequests;
  int count;
  String stars;
  String birthdate;
  String location;
  String status;
  String work ;
  String birthplace;
  String spokenlangs ;

  String mobility ;
  String firstaidcourse ;

  Volunteer(String name, String phoneNumber, String email, bool isSignedIn , String id , String stars , int count
      ,  String birthdate,    String location,String status,String work, String birthplace
      ,  String spokenlangs ,
      String mobility
      , String firstaidcourse  )
      : super(name, phoneNumber, email, Privilege.Volunteer, isSignedIn , id){
    this.birthplace =birthplace;
    this.birthdate = birthdate;
    this.location = location;
    this.status = status;
    this.work = work;
    this.spokenlangs  = spokenlangs;


    this.firstaidcourse = firstaidcourse;
    this.mobility = mobility;

    helpRequests = new List<HelpRequest>();
    this.count  = count;
    this.stars = stars;
  }

}
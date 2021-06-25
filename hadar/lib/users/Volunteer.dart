
import 'dart:collection';
import 'dart:core';


import 'package:hadar/feeds/feed_items/category_scrol.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

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
  List<HelpRequestType> categories;
  List<MyListView> categoriesAsList;

  Volunteer(String name, String phoneNumber, String email, String id ,int lastNotifiedTime, String stars , int count
      , String birthdate, String location, String status, String work, String birthplace
      , String spokenlangs, String mobility, String firstaidcourse ,List<HelpRequestType> categories )
      : super(name, phoneNumber, email, Privilege.Volunteer, id, lastNotifiedTime){
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
    this.categories = categories;
    this.categoriesAsList = [];
    if (categories == null){
      return;
    }
    for(var i = 0; i < this.categories.length; i++){
      this.categoriesAsList.add(MyListView( this.categories[i].description));
    }
  }

}
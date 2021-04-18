import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';

import 'HelpRequestType.dart';

class VerificationRequest {
  UnregisteredUser sender;
  Privilege type;
  DateTime date;
  bool accepted;
  int time;
  String birthdate;
  String location;
  String status;
  String work;

  String birthplace;
  String spokenlangs;

  String firstaidcourse;
  String mobility;

  List<HelpRequestType> services;

  VerificationRequest(UnregisteredUser sender, Privilege type, DateTime date,
      {String birthdate = '',
      String location = '',
      String status = '',
      String work = '',
      String birthplace = '',
      String spokenlangs = '',
      String firstaidcourse = '',
      String mobility = '',
      List<HelpRequestType> services}) {
    accepted = false;
    time = date.millisecondsSinceEpoch;
    this.sender = sender;
    this.status = status;
    this.firstaidcourse = firstaidcourse;
    this.mobility = mobility;
    this.spokenlangs = spokenlangs;
    this.birthplace = birthplace;
    this.birthdate = birthdate;
    this.location = location;
    this.work = work;
    this.type = type;
    this.date = date;

    this.services = services;
  }

  VerificationRequest.organization(
      this.sender, this.type, this.date, this.location, this.services);
}

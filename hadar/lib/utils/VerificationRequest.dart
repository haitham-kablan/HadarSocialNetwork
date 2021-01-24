
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';

class VerificationRequest{
  UnregisteredUser sender;
  Privilege type;
  DateTime date;
  bool accepted;
  int time;
  String birthdate;
  String location;
  String status;
  String work ;
  String birthplace;
  String spokenlangs ;
  String firstaidcourse;
  String mobility;



  VerificationRequest(UnregisteredUser sender, Privilege type,DateTime date, {String birthdate = '' ,
    String location = '',String status = '',String work = '',String birthplace = '',String spokenlangs = '' , String firstaidcourse = '' ,String mobility = ''}) {
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

  }




}
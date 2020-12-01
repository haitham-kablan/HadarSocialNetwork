import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';

class DataBaseService{


  final CollectionReference Helpers_collection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference Usesr_in_need_collection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference Registeration_requests_collection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference Help_requests_type_collection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');


  List<UserInNeed> UserInNeedListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        UserInNeed(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? 0, doc.data()['email'] ?? '')).toList();
  }

  List<Volunteer> VolunteerListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? 0, doc.data()['email'] ?? '')).toList();
  }

  List<HelpRequest> HelpRequestListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        HelpRequest(doc.data()['category'] ?? '', doc.data()['description'] ?? '', doc.data()['date'] ?? '' , doc.data()['sender'] ?? '')).toList();
  }

  Stream<List<Volunteer>> get Helpers{
    return Helpers_collection.snapshots().map(VolunteerListFromSnapShot);

  }

  Stream<List<UserInNeed>> get Usesr_in_need{
    return Usesr_in_need_collection.snapshots().map(UserInNeedListFromSnapShot);
  }

  Stream<List<HelpRequest>> get_User_Help_Requests(String username){
    return Usesr_in_need_collection.doc(username).collection('REQUESTS').snapshots().map(HelpRequestListFromSnapShot);
  }



  Future AddHelpRequestToDataBase(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category;
    to_add['sender'] = helpRequest.sender;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date;

    return await Usesr_in_need_collection.doc(helpRequest.sender).collection('REQUESTS').doc()
    .set(to_add);
  }

}







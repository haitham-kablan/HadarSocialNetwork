import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';

class DataBaseService{


  final CollectionReference helpersCollection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference userInNeedCollection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference registrationRequestsCollection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference helpRequestsTypeCollection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');

/*
  List<UserInNeed> UserInNeedListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        UserInNeed(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? 0, doc.data()['email'] ?? '')).toList();
  }

  List<Volunteer> VolunteerListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? 0, doc.data()['email'] ?? '')).toList();
  }
*/
  List<HelpRequest> helpRequestListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        HelpRequest(doc.data()['category'] ?? '', doc.data()['description'] ?? '', doc.data()['date'] ?? '' , doc.data()['sender'] ?? '')).toList();
  }
/*
  Stream<List<Volunteer>> get Helpers{
    return Helpers_collection.snapshots().map(VolunteerListFromSnapShot);

  }

  Stream<List<UserInNeed>> get Usesr_in_need{
    return Usesr_in_need_collection.snapshots().map(UserInNeedListFromSnapShot);
  }
*/
  Stream<List<HelpRequest>> getUserHelpRequests(String username){
    return userInNeedCollection.doc(username).collection('REQUESTS').snapshots().map(helpRequestListFromSnapShot);
  }



  Future addHelpRequestToDataBase(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category;
    to_add['sender'] = helpRequest.sender;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date;

    return await userInNeedCollection.doc(helpRequest.sender).collection('REQUESTS').doc()
    .set(to_add);
  }

}







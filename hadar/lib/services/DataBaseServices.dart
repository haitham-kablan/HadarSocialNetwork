import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

class DataBaseService{


  final CollectionReference helpersCollection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference userInNeedCollection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('ADMINS');
  final CollectionReference registrationRequestsCollection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference helpRequestsTypeCollection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');


  Future addHelpRequestToDataBaseForUserInNeed(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();

    return await userInNeedCollection.doc(helpRequest.sender_id).collection('REQUESTS').doc()
    .set(to_add);
  }

  Future addUserInNeedToDataBase(User user) async{

    Map<String,dynamic> to_add = Map();

    to_add['name'] = user.name;
    to_add['phoneNumber'] = user.phoneNumber;
    to_add['email'] = user.email;
    to_add['id'] = user.id;
    to_add['privilege'] = user.privilege.toString().substring(10);
    
    return await userInNeedCollection.doc(user.id).set(to_add);
  }

  Future addAdminToDataBase(Admin user) async{

    Map<String,dynamic> to_add = Map();

    to_add['name'] = user.name;
    to_add['phoneNumber'] = user.phoneNumber;
    to_add['email'] = user.email;
    to_add['id'] = user.id;
    to_add['privilege'] = user.privilege.toString().substring(10);

    return await adminsCollection.doc(user.id).set(to_add);
  }

  Future addVolunteerToDataBase(Volunteer user) async{

    Map<String,dynamic> to_add = Map();

    to_add['name'] = user.name;
    to_add['phoneNumber'] = user.phoneNumber;
    to_add['email'] = user.email;
    to_add['id'] = user.id;
    to_add['privilege'] = user.privilege.toString().substring(10);
    to_add['helpRequestsCategories'] = user.helpRequestsCategories.map((e) => e.description).toList();

    return await helpersCollection.doc(user.id).set(to_add);
  }

  Future addHelpRequestTypeDataBase(HelpRequestType helpRequestType) async{

    Map<String,dynamic> to_add = Map();

    to_add['description'] = helpRequestType.description;
    return await helpRequestsTypeCollection.doc().set(to_add);
  }

  Future assignHelpRequestForVolunteer(Volunteer volunteer,HelpRequest helpRequest) async{
    
    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();
    
    return await helpersCollection.doc(volunteer.id).collection('REQUESTS').doc().set(to_add);
  }

  Stream<List<HelpRequest>> getUserHelpRequests(User user) {

    return userInNeedCollection.doc(user.id).collection('REQUESTS')
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  Stream<List<HelpRequest>> getVolHelpRequests(Volunteer volunteer) {

    return helpersCollection.doc(volunteer.id).collection('FEED')
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  Stream<List<HelpRequestType>> getHelpRequestsTypes() {

    return helpRequestsTypeCollection
        .snapshots()
        .map(helpRequestTypeListFromSnapShot);
  }

  Stream<List<Volunteer>> getAllVolunteersForSpecificRequest(HelpRequestType helpRequestType){

    CollectionReference col = helpersCollection.where('helpRequestsCategories' , arrayContains: helpRequestType.description );
    return col
        .snapshots()
        .map(VolunteerListFromSnapShot);
  }
  
  


}


List<HelpRequest> helpRequestListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      HelpRequest(HelpRequestType(doc.data()['category']) ?? '', doc.data()['description'] ?? '', DateTime.parse(doc.data()['date']) ?? '' , doc.data()['sender_id'] ?? '')).toList();
}

List<HelpRequestType> helpRequestTypeListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      HelpRequestType(doc.data()['description'] ?? '')).toList();
}

List<Volunteer> VolunteerListFromSnapShot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc) =>
      Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? '' , (doc.data()['helpRequestsCategories'] as List<String>).map((e)
          => HelpRequestType(e)).toList() ?? List<HelpRequestType>())).toList();
}







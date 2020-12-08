//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

class DataBaseService{

  static final String user_in_need_requests = 'REQUESTS';
  static final String volunteer_accepted_requests = 'ACCEPTED_REQUESTS';
  static final String volunteer_pending_requests = 'PENDING_REQUESTS';

  final CollectionReference helpersCollection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference userInNeedCollection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('ADMINS');
  final CollectionReference registrationRequestsCollection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference helpRequestsTypeCollection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');


  /*
  THIS FUNCTION WILL AUTOMATICALLY ADD THE REQUEST TO ALL THE RELEVANT
  VOULNTEERS
   */
  Future addHelpRequestToDataBaseForUserInNeed(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();


     await userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id)
    .set(to_add).catchError((error) => print("problem in addHelpRequestToDataBaseForUserInNeed"));
     
    return await helpersCollection.where('helpRequestsCategories' , arrayContains: helpRequest.category.description )
        .get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) { 
            doc.reference.collection(volunteer_pending_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add).catchError((error) => print("failed to add for this voulnteer"));
          })
    } );


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

  /*
  this function move the request from pending to accepted collection.
  make sure to put the exact date of the request and not the current date
   */
  Future assignHelpRequestForVolunteer(Volunteer volunteer,HelpRequest helpRequest) async{
    
    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();
    
    await helpersCollection.doc(volunteer.id).collection(volunteer_accepted_requests).doc(to_add['date']+"-"+helpRequest.sender_id).set(to_add);
    return await helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests).doc(to_add['date']+"-"+helpRequest.sender_id).delete();
  }

  /*
  before u call this function u must type await . so u only user the returend value when the fuchntion ends
   */
  Future getUserById(String id,Privilege privilege) async{

    DocumentSnapshot doc;

    if (privilege == Privilege.UserInNeed){

      await userInNeedCollection.doc(id).get()
      .then((document) => doc = document);

      return UserInNeed(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? '' );
    }

    if (privilege == Privilege.Admin){

      await adminsCollection.doc(id).get()
          .then((document) => doc = document);
      return  Admin(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? '' );
    }

    if (privilege == Privilege.Volunteer){

      await helpersCollection.doc(id).get()
          .then((document) => doc = document);
      return  Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? '' , (doc.data()['helpRequestsCategories'] as List<String>).map((e)
          => HelpRequestType(e)).toList() ?? List<HelpRequestType>());
    }
  }

  Stream<List<HelpRequest>> getUserHelpRequests(User user) {

    return userInNeedCollection.doc(user.id).collection(user_in_need_requests)
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  Stream<List<HelpRequest>> getVolPendingRequests(Volunteer volunteer) {

    return helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests)
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  Stream<List<HelpRequest>> getVolAceeptedRequests(Volunteer volunteer) {

    return helpersCollection.doc(volunteer.id).collection(volunteer_accepted_requests)
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







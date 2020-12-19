//import 'dart:html';

//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

class DataBaseService{

  static final String user_in_need_requests = 'REQUESTS';
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
    to_add['time'] = helpRequest.time;
    to_add['handler_id'] = helpRequest.handler_id;


    await userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id)
        .set(to_add).catchError((error) => print("problem in addHelpRequestToDataBaseForUserInNeed"));

    return await helpersCollection.where('helpRequestsCategories' , arrayContains: helpRequest.category.description )
        .get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        doc.reference.collection(volunteer_pending_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add).catchError((error) => print("failed to add for this voulnteer"));
      })
    } );


  }

  Future addUserInNeedToDataBase(hadar.User user) async{

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

    Map<String,dynamic> to_update = Map();
    to_update['handler_id'] = volunteer.id;

    QuerySnapshot docs = await helpersCollection.get();

    for (QueryDocumentSnapshot doc_snap_shot in docs.docs){
      DocumentReference curr_doc = doc_snap_shot.reference;
      if(curr_doc.id != volunteer.id) {
        curr_doc.collection(volunteer_pending_requests).doc(
            helpRequest.date.toString() + "-" + helpRequest.sender_id).delete();
      }
    }

    helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests).doc(helpRequest.date.toString() + "-" + helpRequest.sender_id).update(to_update);
  }

  /*
  before u call this function u must type await . so u only use the returned value when the function  ends
  and also u should check if the returned  value is not null (if it is null it means the user hasnt been found)
  one more thing - u should relate to the returned value using as because future return dynamic type,
  for exmaple :
    onPressed: () async {
                UserInNeed userInNeed = (await DataBaseService().getUserById("123456789", Privilege.UserInNeed)) as UserInNeed;
                print("printing user");
                if (userInNeed == null){
                  print('got null');
                }else {
                  print(userInNeed.name);
                  print(userInNeed.id);
                  print(userInNeed.phoneNumber);
                }
              },
      here i know that i want user in need , therfore i put as user in need , so i can
      reach its fields
   */
  Future getUserById(String id,hadar.Privilege privilege) async{

    DocumentSnapshot doc;

    if (privilege == hadar.Privilege.UserInNeed){

      await userInNeedCollection.doc(id).get()
          .then((document) => doc = document.exists ? document : null);

      if (doc == null){
        return null;
      }

      return UserInNeed(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['id'] ?? '' );
    }

    if (privilege == hadar.Privilege.Admin){

      await adminsCollection.doc(id).get()
          .then((document) => doc = document);

      if (doc == null){
        return null;
      }

      return  Admin(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['id'] ?? '' );
    }

    if (privilege == hadar.Privilege.Volunteer){

      await helpersCollection.doc(id).get()
          .then((document) => doc = document);

      if (doc == null){
        return null;
      }

      return  Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['id'] ?? '' , get_categoreis(doc));
    }
  }

  Stream<List<HelpRequest>> getUserHelpRequests(hadar.User user) {

    return userInNeedCollection.doc(user.id).collection(user_in_need_requests).orderBy('time',descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  Stream<List<HelpRequest>> getVolPendingRequests(Volunteer volunteer) {

    return helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests).orderBy('time',descending: true)
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


  Future<List<HelpRequestType>> helpRequestAsAlist() async {

    List<HelpRequestType> list1 = List<HelpRequestType>();

    await helpRequestsTypeCollection.get().then((querySnapshot){
      querySnapshot.docs.forEach((element){
        list1.add(HelpRequestType(element.data()['description']));
      });
    });

    return list1;

  }


  Future getUserByEmail(String email,hadar.Privilege privilege) async{

    QuerySnapshot querySnapshot = null;
    DocumentSnapshot doc = null;

    if (privilege == hadar.Privilege.UserInNeed){

      querySnapshot = await userInNeedCollection.where('email',isEqualTo: email).get();

      if (querySnapshot.size == 0){
        return null;
      }
      for(int i = 0 ; i< querySnapshot.docs.length ; i++){
        doc = querySnapshot.docs[i];
      }

      return UserInNeed(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['id'] ?? '' );
    }

    if (privilege == hadar.Privilege.Admin){

      querySnapshot = await adminsCollection.where('email',isEqualTo: email).get();

      if (querySnapshot.size == 0){
        return null;
      }
      for(int i = 0 ; i< querySnapshot.docs.length ; i++){
        doc = querySnapshot.docs[i];
      }

      return  Admin(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['id'] ?? '' );
    }

    if (privilege == hadar.Privilege.Volunteer){

      querySnapshot = await helpersCollection.where('email',isEqualTo: email).get();

      if (querySnapshot.size == 0){
        return null;
      }
      for(int i = 0 ; i< querySnapshot.docs.length ; i++){
        doc = querySnapshot.docs[i];
      }

      return  Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['id'] ?? '' , get_categoreis(doc));
    }
  }

  /*/
  check the privilage of the returned type and use as to correct its actual type
   */
  Future getCurrentUser() async {
    fb_auth.User curr_db_user = fb_auth.FirebaseAuth.instance.currentUser;
    hadar.User user;
    if(curr_db_user == null){
      return null;
    }
    user = await getUserByEmail(curr_db_user.email, hadar.Privilege.UserInNeed);
    if(user == null){
      user = await getUserByEmail(curr_db_user.email, hadar.Privilege.Admin);
      if(user == null){
        user = await getUserByEmail(curr_db_user.email, hadar.Privilege.Volunteer);
      }
    }

    return user;
  }

  Future<bool> is_id_taken(String id)async{

    DocumentSnapshot snapShot_helper = await helpersCollection.doc(id).get();
    DocumentSnapshot snapShot_need = await userInNeedCollection.doc(id).get();
    DocumentSnapshot snapShot_admin = await adminsCollection.doc(id).get();
    if (snapShot_helper.exists || snapShot_need.exists || snapShot_admin.exists ) {
      return true;
    }
    return false;
  }

}


List<HelpRequest> helpRequestListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      HelpRequest(HelpRequestType(doc.data()['category']) ?? '', doc.data()['description'] ?? '', DateTime.parse(doc.data()['date']) ?? '' , doc.data()['sender_id'] ?? '',doc.data()['handler_id'] ?? '')).toList();
}

List<HelpRequestType> helpRequestTypeListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      HelpRequestType(doc.data()['description'] ?? '')).toList();
}

List<Volunteer> VolunteerListFromSnapShot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc) =>
      Volunteer(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? '' , get_categoreis(doc)));
}

List<HelpRequestType> get_categoreis(DocumentSnapshot doc){

  List<HelpRequestType> categories = [];
  for (var type in doc.data()['helpRequestsCategories']){
    categories.add(HelpRequestType(type as String));
  }

  return categories;




}





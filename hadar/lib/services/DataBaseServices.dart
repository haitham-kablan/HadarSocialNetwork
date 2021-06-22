//import 'dart:html';

//import 'dart:html';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hadar/feeds/feed_items/category_scrol.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/users/Admin.dart';

import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Organization.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/UsersInquiry.dart';
import 'package:hadar/utils/VerificationRequest.dart';

import '../main.dart';

class DataBaseService{

  //static final String user_in_need_requests = 'REQUESTS';
  //static final String volunteer_pending_requests = 'PENDING_REQUESTS';
  static final String verification_requests = 'VERIFICATION_REQUESTS';
  String current_vol_id = '';


  final CollectionReference helpersCollection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference userInNeedCollection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('ADMINS');
  final CollectionReference inquiryCollection = FirebaseFirestore.instance.collection('Inqury');
  final CollectionReference organizationsCollection = FirebaseFirestore.instance.collection('ORGANIZATIONS');
  final CollectionReference registrationRequestsCollection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference helpRequestsTypeCollection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');
  final CollectionReference verificationsRequestsCollection = FirebaseFirestore.instance.collection(verification_requests);
  final CollectionReference allHelpsRequestsCollection = FirebaseFirestore.instance.collection('ALL_HELP_REQUESTS');
  final CollectionReference tokens = FirebaseFirestore.instance.collection('TOKENS');
  final CollectionReference usersLanguagesCollection = FirebaseFirestore.instance.collection('USERS_LANGUAGES');




  Future rateVolunteer(String to_rate_id , double number_of_stars) async{


    DocumentReference documentReference = helpersCollection.doc(to_rate_id.toString());
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      // Update the follower count based on the current count
      // Note: this could be done without a transaction
      // by updating the population using FieldValue.increment()

      int newCount = snapshot['count'] + 1;
      String old_stars = snapshot['stars'];
      String new_stars = (double.parse(old_stars) + number_of_stars).toStringAsFixed(1);

      // Perform an update on the document
      transaction.update(documentReference, {'count': newCount});
      transaction.update(documentReference, {'stars': new_stars});

    })
        .then((value) => print("added stars $value"))
        .catchError((error) => print("Failed to add stars: $error"));
  }
  /*/
    this will check if the user is verifeid
   */
  Future<bool> checkIfVerfied(String email) async{

    bool ans;
    await verificationsRequestsCollection.doc(email).get().then((value) => ans = !value.exists);
    return ans;

  }

  Future addVerficationRequestToDb(VerificationRequest verificationRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['sender_id'] = verificationRequest.sender.id;
    to_add['email'] = verificationRequest.sender.email;
    to_add['name'] = verificationRequest.sender.name;
    to_add['phoneNumber'] = verificationRequest.sender.phoneNumber;
    to_add['accepted'] = verificationRequest.accepted;
    to_add['date'] = verificationRequest.date.toString();
    to_add['type'] = verificationRequest.type.toString().substring(10);
    to_add['time'] = verificationRequest.time;
    to_add['birthdate'] = verificationRequest.birthdate;
    to_add['location'] = verificationRequest.location;
    to_add['status'] = verificationRequest.status;
    to_add['work'] = verificationRequest.work;
    to_add['birthplace'] = verificationRequest.birthplace;
    to_add['spokenlangs'] = verificationRequest.spokenlangs;
    to_add['firstaidcourse'] = verificationRequest.firstaidcourse;
    to_add['mobility'] = verificationRequest.mobility;

    //manage services for organizations
    List<String> services = [''];
    if(verificationRequest.type != Privilege.Organization){
      services.add('');
    }
    else{
      services = verificationRequest.services.map((helpRequestType) => helpRequestType.description).toList();
    }
    to_add['services'] = services;
    return await verificationsRequestsCollection.doc(verificationRequest.sender.email).set(to_add);
    
  }

  Future RemoveOrginazation(String name) async{

    await organizationsCollection.doc(name).delete();

  }

  Future updateVolCategories(List<HelpRequestType> newList,Volunteer vol) async{
    vol.categoriesAsList = newList.map((e) => MyListView(e.description)).toList();
    Map<String,dynamic> to_update = Map();
    to_update['categories'] = newList.map((e) => e.description).toList();
    await helpersCollection.doc(vol.id).update(to_update);
  }

  Future RemoveCategory(HelpRequestType helpRequestType) async{

    Map<String,dynamic> update = Map();
    update['category'] = 'אחר';
    await helpRequestsTypeCollection.doc(helpRequestType.description).delete();
    QuerySnapshot querySnapshot =
    await allHelpsRequestsCollection.where('category' , isEqualTo:helpRequestType.description ).get();

    if (querySnapshot.size == 0) {
      return null;
    }

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      allHelpsRequestsCollection.doc(querySnapshot.docs[i].id).update(update);
    }

  }

  Future RemoveCurrentuserFromAuthentication() async{
    fb_auth.User curr_db_user = fb_auth.FirebaseAuth.instance.currentUser;
    curr_db_user.delete();
  }

  Future RemoveUserfromdatabase(hadar.User user) async {


    //REMOVE FROM ALL HLEP REQUEST
    //REMOVE FROM SUITABLE COLLECTION
    if (user.privilege == Privilege.Admin){
      adminsCollection.doc(user.id).delete();
    }else if (user.privilege == Privilege.Volunteer){
      helpersCollection.doc(user.id).delete();
    }else{
      userInNeedCollection.doc(user.id).delete();
    }

    if (user.privilege == Privilege.UserInNeed) {
      QuerySnapshot querySnapshot = await allHelpsRequestsCollection.where(
          'sender_id', isEqualTo: user.id).get();

      if (querySnapshot.size == 0) {
        return null;
      }

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        allHelpsRequestsCollection.doc(querySnapshot.docs[i].id).delete();
      }
    }

    if (user.privilege == Privilege.Volunteer){
      Map<String,dynamic> to_update = Map();
      to_update['handler_id'] = "";
      to_update['status'] = Status.AVAILABLE.toString().substring(7);
      QuerySnapshot querySnapshot = await allHelpsRequestsCollection.where(
          'handler_id', isEqualTo: user.id).get();

      if (querySnapshot.size == 0) {
        return null;
      }

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        allHelpsRequestsCollection.doc(querySnapshot.docs[i].id).update(to_update);
      }

    }


  }
  Future DenyVerficationRequest(VerificationRequest verificationRequest){
    verificationsRequestsCollection.doc(verificationRequest.sender.email).delete();

  }
  /*/
    this function will also add the user to db and delte its request
    in case of admin or user in need catoergires are null

   */
  Future AcceptVerificationRequest(VerificationRequest verificationRequest , List<HelpRequestType> categories){

    switch (verificationRequest.type){

      case Privilege.Admin:
        Admin admin_to_add = Admin(verificationRequest.sender.name, verificationRequest.sender.phoneNumber, verificationRequest.sender.email, verificationRequest.sender.id, verificationRequest.time);
        addAdminToDataBase(admin_to_add);
        verificationsRequestsCollection.doc(admin_to_add.email).delete();
        break;
      case Privilege.UserInNeed:
        // UserInNeed UserInNeed_to_add = UserInNeed(verificationRequest.sender.name, verificationRequest.sender.phoneNumber, verificationRequest.sender.email, false, verificationRequest.sender.id);
        // addUserInNeedToDataBase(UserInNeed_to_add);
        // verificationsRequestsCollection.doc(UserInNeed_to_add.email).delete();
        assert(false);
        break;
      case Privilege.Volunteer:

        Volunteer Volunteer_to_add = Volunteer(verificationRequest.sender.name, verificationRequest.sender.phoneNumber, verificationRequest.sender.email, verificationRequest.sender.id, verificationRequest.time,'0',0,verificationRequest.birthdate,verificationRequest.location,verificationRequest.status,verificationRequest.work,verificationRequest.birthplace,verificationRequest.spokenlangs,verificationRequest.mobility,verificationRequest.firstaidcourse,[]);
        addVolunteerToDataBase(Volunteer_to_add);
        verificationsRequestsCollection.doc(Volunteer_to_add.email).delete();
        break;

      default:
        assert(false);
        break;
    }

  }

  Stream<List<VerificationRequest>> getVerificationRequests() {

    return verificationsRequestsCollection.orderBy('time',descending: true)
        .snapshots()
        .map(VerficationRequestListFromSnapShot);
  }
  
  Future<bool> hasVerificationRequestsAfterTimestamp(int timestamp) async {
    var requests = await verificationsRequestsCollection
        .where('time', isGreaterThan: timestamp)
        .get();

    return requests.size > 0;
  }

  Future updateUserLastNotifiedTime(hadar.User user) async{

    Map<String,dynamic> toUpdate = Map();
    toUpdate['lastNotifiedTime'] = DateTime.now().millisecondsSinceEpoch;

    switch (user.privilege){
      case Privilege.Admin:
        adminsCollection.doc(user.id).update(toUpdate);
        break;
      case Privilege.Volunteer:
        helpersCollection.doc(user.id).update(toUpdate);
        break;
      case Privilege.UserInNeed:
        userInNeedCollection.doc(user.id).update(toUpdate);
        break;
      default:
        return;
    }
  }


    /*
  THIS FUNCTION WILL AUTOMATICALLY ADD THE REQUEST TO ALL THE RELEVANT
  VOULNTEERS -- nooooooooooo !!!
  it now add them to pending request collection
   */
  // Future addHelpRequestToDataBaseForUserInNeed(HelpRequest helpRequest) async{
  //
  //   Map<String,dynamic> to_add = Map();
  //   to_add['category'] = helpRequest.category.description;
  //   to_add['sender_id'] = helpRequest.sender_id;
  //   to_add['description'] = helpRequest.description;
  //   to_add['date'] = helpRequest.date.toString();
  //   to_add['time'] = helpRequest.time;
  //   to_add['handler_id'] = helpRequest.handler_id;
  //   to_add['verfied'] = helpRequest.verfied;
  //
  //
  //    userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id)
  //       .set(to_add).catchError((error) => print("problem in addHelpRequestToDataBaseForUserInNeed"));
  //
  //    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add);
  //
  //
  //
  //
  // }

  Future<int> getSizeOfHelpReqType(HelpRequestType helpRequestType,String id) async {
    List<HelpRequest> list = await get_requests_for_category(helpRequestType,id).first;
    return list.length;

    // QuerySnapshot querySnapshot = await allHelpsRequestsCollection.where('category',isEqualTo: helpRequestType.description).get();
    // int counter = 0;
    //
    // if (querySnapshot.size == 0){
    //   return 0;
    // }
    //
    // for(int i = 0 ; i< querySnapshot.docs.length ; i++){
    //    DocumentSnapshot doc = querySnapshot.docs[i];
    //    doc['name'] ?? '';
    //    if(doc['']){
    //
    //    }
    // }
    //
    // return counter;
  }
  Future addHelpRequestToDataBaseForUserInNeed(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();
    to_add['time'] = helpRequest.time;
    to_add['handler_id'] = helpRequest.handler_id;
    to_add['status'] = helpRequest.status.toString().substring(7);
    to_add['reject_reason'] = helpRequest.reject_reason;
    to_add['location'] = helpRequest.location;

    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add);

  }

  Future addInquryToDataBase(UserInquiry userInquiry) async{

    Map<String,dynamic> to_add = Map();
    to_add['name'] = userInquiry.name;
    to_add['id'] = userInquiry.id;
    to_add['phoneNumber'] = userInquiry.phoneNumber;
    to_add['reasonForInquiry'] = userInquiry.reasonForInquiry;
    to_add['description'] = userInquiry.description;
    to_add['date'] = userInquiry.date.toString();

    inquiryCollection.doc(userInquiry.date.toString()+"-"+userInquiry.id).set(to_add);

  }



  /*/
    this function will also put the reqeust to the relvenat voulnteers
   */
  // Future verify_help_request(HelpRequest helpRequest) async{
  //
  //   Map<String,dynamic> to_add = Map();
  //   to_add['category'] = helpRequest.category.description;
  //   to_add['sender_id'] = helpRequest.sender_id;
  //   to_add['description'] = helpRequest.description;
  //   to_add['date'] = helpRequest.date.toString();
  //   to_add['time'] = helpRequest.time;
  //   to_add['handler_id'] = helpRequest.handler_id;
  //   to_add['verfied'] = true;
  //
  //   allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();
  //
  //   helpersCollection.where('helpRequestsCategories' , arrayContains: helpRequest.category.description )
  //       .get().then((QuerySnapshot querySnapshot) => {
  //     querySnapshot.docs.forEach((doc) {
  //       doc.reference.collection(volunteer_pending_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add).catchError((error) => print("failed to add for this voulnteer"));
  //     })
  //   } );
  //
  //   Map<String,dynamic> to_update = Map();
  //   to_update['verfied'] = true;
  //
  //   userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).update(to_update);
  //
  //
  //
  // }

  Future verify_help_request(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['status'] = Status.AVAILABLE.toString().substring(7);

    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).update(to_add);


  }

  // //TODO ALSO CHECK HOW TO REMOVE THE USER FROM THE AUTH
  // Future cancel_help_reqeust(HelpRequest helpRequest) async {
  //
  //   allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();
  //   userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();
  //
  // }
  //TODO ALSO CHECK HOW TO REMOVE THE USER FROM THE AUTH
  Future delete_help_reqeust(HelpRequest helpRequest) async {
    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();
  }
  Future cancel_help_reqeust(HelpRequest helpRequest) async {
    helpRequest.status = Status.REJECTED;
    addHelpRequestToDataBaseForUserInNeed(helpRequest);
    //allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();
  }

  Future addUserInNeedToDataBase(UserInNeed user) async{

    Map<String,dynamic> to_add = Map();

    to_add['name'] = user.name;
    to_add['phoneNumber'] = user.phoneNumber;
    to_add['email'] = user.email;
    to_add['id'] = user.id;
    to_add['privilege'] = user.privilege.toString().substring(10);

    to_add['Age'] = user.Age;
    to_add['Location'] = user.Location;
    to_add['Status'] = user.Status;
    to_add['numKids'] = user.numKids;
    to_add['eduStatus'] = user.eduStatus;
    to_add['homePhone'] = user.homePhone;
    to_add['specialStatus'] = user.specialStatus;
    to_add['Rav7a'] = user.Rav7a;

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
    to_add['count'] = user.count;
    to_add['stars'] = user.stars;
    to_add['privilege'] = user.privilege.toString().substring(10);
    to_add['birthdate'] = user.birthdate;
    to_add['location'] = user.location;
    to_add['status'] = user.status;
    to_add['work'] = user.work;
    to_add['birthplace'] = user.birthplace;
    to_add['spokenlangs'] = user.spokenlangs;
    to_add['firstaidcourse'] = user.firstaidcourse;
    to_add['mobility'] = user.mobility;
    to_add['categories'] = user.categories.map((e) => e.description).toList();

    return await helpersCollection.doc(user.id).set(to_add);
  }

  Future addOrganizationToDataBase(Organization organization) async{
    Map<String,dynamic> to_add = Map();

    to_add['name'] = organization.name;
    to_add['phoneNumber'] = organization.phoneNumber;
    to_add['email'] = organization.email;
    to_add['location'] = organization.location;

    //convert from a list of HelpRequestType to a list of Strings
    var services = organization.services.map((service) => service.description).toList();
    to_add['services'] = services;


    return await organizationsCollection.doc(organization.name).set(to_add);
  }


  Future addHelpRequestTypeDataBase(HelpRequestType helpRequestType) async{

    Map<String,dynamic> to_add = Map();

    to_add['description'] = helpRequestType.description;
    return await helpRequestsTypeCollection.doc(helpRequestType.description).set(to_add);
  }



  /*
  this function move the request from pending to accepted collection.
  make sure to put the exact date of the request and not the current date
   */
  // Future assignHelpRequestForVolunteer(Volunteer volunteer,HelpRequest helpRequest) async{
  //
  //   Map<String,dynamic> to_update = Map();
  //   to_update['handler_id'] = volunteer.id;
  //
  //   QuerySnapshot docs = await helpersCollection.get();
  //
  //   for (QueryDocumentSnapshot doc_snap_shot in docs.docs){
  //     DocumentReference curr_doc = doc_snap_shot.reference;
  //     if(curr_doc.id != volunteer.id) {
  //       curr_doc.collection(volunteer_pending_requests).doc(
  //           helpRequest.date.toString() + "-" + helpRequest.sender_id).delete();
  //     }
  //   }
  //
  //   helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests).doc(helpRequest.date.toString() + "-" + helpRequest.sender_id).update(to_update);
  //   userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString() + "-" + helpRequest.sender_id).update(to_update);
  // }
  Future assignHelpRequestForVolunteer(Volunteer volunteer,HelpRequest helpRequest) async{

    Map<String,dynamic> to_update = Map();
    to_update['handler_id'] = volunteer.id;
    to_update['status'] = Status.APPROVED.toString().substring(7);
    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).update(to_update);
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
  //TODO tell hsenn
  Future getUserById(String id,Privilege privilege) async{

    DocumentSnapshot doc;
    int defaultLastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
    if (privilege == Privilege.UserInNeed){

      await userInNeedCollection.doc(id).get()
          .then((document) => doc = document.exists ? document : null);

      if (doc == null){
        return null;
      }

      return UserInNeed(getTypeFromString(doc['privilege']) ,doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '',
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime ,doc['Age'] ?? 0 ,doc['Location'] ?? '' ,doc['Status'] ?? '' , doc['numKids'] ?? 0, doc['eduStatus'] ?? '', doc['homePhone'] ?? '',doc['specialStatus'] ?? '' ,doc['Rav7a'] ?? '' );
    }

    if (privilege == Privilege.Admin){

      await adminsCollection.doc(id).get()
          .then((document) => doc = document.exists ? document : null);

      if (doc == null){
        return null;
      }

      return  Admin(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '',
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime );
    }

    if (privilege == Privilege.Volunteer){

      await helpersCollection.doc(id).get()
          .then((document) => doc = document.exists ? document : null);

      if (doc == null){
        return null;
      }

      return  Volunteer(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime  ,doc['stars'] ?? 0,
          doc['count'] ?? 0 ,doc['birthdate'] ?? ''  ,doc['location'] ?? ''  ,doc['status'] ?? ''  ,
          doc['work'] ?? ''  ,doc['birthplace'] ?? ''  ,doc['spokenlangs'] ?? ''  ,doc['firstaidcourse'] ?? ''  ,doc['mobility'] ?? '' , convertCategoreisAsStringToHLT(doc['categories'] ?? []));
    }


  }

  // Stream<List<HelpRequest>> getUserHelpRequests(hadar.User user) {
  //
  //   return userInNeedCollection.doc(user.id).collection(user_in_need_requests).orderBy('time',descending: true)
  //       .snapshots()
  //       .map(helpRequestListFromSnapShot);
  // }

  Stream<List<HelpRequest>> getUserHelpRequests(hadar.User user) {

    return allHelpsRequestsCollection.where('sender_id' , isEqualTo: user.id).orderBy('time',descending: true)
      .snapshots().map(helpRequestListFromSnapShot);
    //TODO - u might need to delete order by time
  }
  Stream<List<HelpRequest>> getAll_waiting_Requests_for_volunteer(String id) {

    current_vol_id = id;
    return allHelpsRequestsCollection.orderBy('time' , descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShotForSpecificVolunteer);

  }

  Stream<List<HelpRequest>> getAll_waiting_Requests() {


    return allHelpsRequestsCollection.where('status' , isEqualTo: Status.AVAILABLE.toString().substring(7)).orderBy('time' , descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);

  }

  Stream<List<HelpRequest>> getAll_unverfied_requests_Requests() {


    return allHelpsRequestsCollection.where('status' , isEqualTo: Status.UNVERFIED.toString().substring(7)).orderBy('time' , descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);

  }
  Stream<List<HelpRequest>> getAll_approved_Requests() {


    return allHelpsRequestsCollection.where('status' , isEqualTo: Status.APPROVED.toString().substring(7)).orderBy('time' , descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);

  }

  Future<bool> hasUnverifiedHelpRequestsAfter(int timestamp) async {

    var requests = await allHelpsRequestsCollection
        .where('status' , isEqualTo: Status.UNVERFIED.toString().substring(7))
        .where('time', isGreaterThan: timestamp)
        .get();

    return requests.size > 0;
  }

  Future<bool> hasApprovedHelpRequestsAfter(int timestamp) async {

    var requests = await allHelpsRequestsCollection
        .where('status' , isEqualTo: Status.APPROVED.toString().substring(7))
        .where('time', isGreaterThan: timestamp)
        .get();
    return requests.size > 0;
  }

  Future<bool> hasAvailableHelpRequestsAfter(int timestamp) async {

    var requests = await allHelpsRequestsCollection
        .where('status' , isEqualTo: Status.AVAILABLE.toString().substring(7))
        .where('time', isGreaterThan: timestamp)
        .get();
    return requests.size > 0;
  }

  Stream<List<UserInquiry>> getAll_inquires_for_user(String id) {


    return inquiryCollection.where('id',isEqualTo: id).orderBy('date',descending: true)
        .snapshots()
        .map(UserInqurytListFromSnapShot);

  }

  Stream<List<UserInquiry>> getAll_inquires() {


    return inquiryCollection.orderBy('date',descending: true)
        .snapshots()
        .map(UserInqurytListFromSnapShot);

  }

  // Stream<List<HelpRequest>> getVolPendingRequests(Volunteer volunteer) {
  //
  //   return helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests).orderBy('time',descending: true)
  //       .snapshots()
  //       .map(helpRequestListFromSnapShot);
  // }

  Stream<List<HelpRequest>> getVolAcceptedRequestsRequests(Volunteer volunteer) {

    return allHelpsRequestsCollection.where('handler_id' , isEqualTo:volunteer.id).orderBy('time',descending: true)
        .snapshots().map(helpRequestListFromSnapShot);
    //TODO - might delete time
  }


  Stream<List<HelpRequestType>> getHelpRequestsTypes() {

    return helpRequestsTypeCollection
        .snapshots()
        .map(helpRequestTypeListFromSnapShot);
  }

  // Stream<List<Volunteer>> getAllVolunteersForSpecificRequest(HelpRequestType helpRequestType){
  //
  //   CollectionReference col = helpersCollection.where('helpRequestsCategories' , arrayContains: helpRequestType.description );
  //   return col
  //       .snapshots()
  //       .map(VolunteerListFromSnapShot);
  // }

  Stream<List<HelpRequest>> get_requests_for_category(HelpRequestType helpRequestType , String id){
    current_vol_id = id;

    //TODO - u might delete time
    return allHelpsRequestsCollection.where('category' , isEqualTo: helpRequestType.description).orderBy('time' , descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShotVerified);

  }
/*
  Future<List<HelpRequestType>> getOrganizationServices(Organization organization){
    //todo: implement this
    //returns the services that this organization provides
    //implementation: get the field services from this organization in
    //organizationsCollection and convert it from List<String> to List<HelpRequestType>

  }

  Future<List<HelpRequestType>> helpRequestTypesAsList() async {

    List<HelpRequestType> list1 = List<HelpRequestType>();

    await helpRequestsTypeCollection.get().then((querySnapshot){
      querySnapshot.docs.forEach((element){
        list1.add(HelpRequestType(element['description']));
      });
    });

    return list1;

  }
*/

  Stream<List<Volunteer>> getAllVolunteers(){

    return helpersCollection
        .snapshots()
        .map(VolunteerListFromSnapShot);
  }

  Stream<List<Admin>> getAllAdmins(){

    return adminsCollection
        .snapshots()
        .map(AdminListFromSnapShot);
  }

  Stream<List<UserInNeed>> getAllUsersInNeed(){

    return userInNeedCollection
        .snapshots()
        .map(UserInNeedListFromSnapShot);
  }

  Stream<List<Organization>> getAllOrganizations(){

    return organizationsCollection
        .snapshots()
        .map(organizationListFromSnapShot);
  }

  Future<List<HelpRequestType>> helpRequestTypesAsList() async {

    List<HelpRequestType> list1 = List<HelpRequestType>();

    await helpRequestsTypeCollection.get().then((querySnapshot){
      querySnapshot.docs.forEach((element){
        list1.add(HelpRequestType(element['description']));
      });
    });

    return list1;

  }



  Future getUserByEmail(String email,Privilege privilege) async{

    QuerySnapshot querySnapshot = null;
    DocumentSnapshot doc = null;
    int defaultLastNotifiedTime = DateTime.now().millisecondsSinceEpoch;

    if (privilege == Privilege.UserInNeed){

      querySnapshot = await userInNeedCollection.where('email',isEqualTo: email).get();

      if (querySnapshot.size == 0){
        return null;
      }
      for(int i = 0 ; i< querySnapshot.docs.length ; i++){
        doc = querySnapshot.docs[i];
      }

      return UserInNeed(Privilege.UserInNeed , doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime, doc['Age'] ?? 0 ,doc['Location'] ?? '' ,doc['Status'] ?? '' , doc['numKids'] ?? 0, doc['eduStatus'] ?? '', doc['homePhone'] ?? '',doc['specialStatus'] ?? '' ,doc['Rav7a'] ?? '' );
    }

    if (privilege == Privilege.Admin){

      querySnapshot = await adminsCollection.where('email',isEqualTo: email).get();

      if (querySnapshot.size == 0){
        return null;
      }
      for(int i = 0 ; i< querySnapshot.docs.length ; i++){
        doc = querySnapshot.docs[i];
      }

      return  Admin(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime );
    }

    if (privilege == Privilege.Volunteer){

      querySnapshot = await helpersCollection.where('email',isEqualTo: email).get();

      if (querySnapshot.size == 0){
        return null;
      }
      for(int i = 0 ; i< querySnapshot.docs.length ; i++){
        doc = querySnapshot.docs[i];
      }

      return  Volunteer(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime, doc['stars'] ?? 0,doc['count'] ?? 0 ,doc['birthdate'] ?? ''  ,doc['location'] ?? ''  ,doc['status'] ?? ''  ,doc['work'] ?? ''  ,doc['birthplace'] ?? ''  ,doc['spokenlangs'] ?? ''  ,doc['firstaidcourse'] ?? ''  ,doc['mobility'] ?? '' ,convertCategoreisAsStringToHLT(doc['categories'] ?? []));
    }

  }

  /*/
  check the privilage of the returned type and use as to correct its actual type
   */
  Future getCurrentUser() async {
    fb_auth.User curr_db_user = fb_auth.FirebaseAuth.instance.currentUser;
    hadar.User user = null;
    if(curr_db_user == null){
      return null;
    }
    user = await getUserByEmail(curr_db_user.email, Privilege.UserInNeed);
    if(user == null){
      user = await getUserByEmail(curr_db_user.email, Privilege.Admin);
      if(user == null){
        user = await getUserByEmail(curr_db_user.email, Privilege.Volunteer);
      }
    }

    return user;
  }
  /*Future get_token(String email) async{

    String token_to_return = null;
    await tokens.doc(email).get().then((value) => token_to_return = value.exists ? value.get('token') : null);
    return token_to_return;
  }
  Future add_user_token_to_db() async{

    if (CurrentUser.curr_user == null){
      return;
    }
    String token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      Map<String,dynamic> to_add = new Map();
      to_add['token'] = token;
      to_add['email'] = CurrentUser.curr_user.email;
      tokens.doc(CurrentUser.curr_user.email).set(to_add);
    }

  }*/
  Future Sign_out(var context) async{
    await fb_auth.FirebaseAuth.instance.signOut();
    //print('length is :' , Navigator.)
    // while (Navigator.canPop(context)){
    //   Navigator.pop(context);
    // }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LogInPage(),
      ),
          (route) => false,
    );


  }
  Future<bool> is_id_taken(String id,String email)async{

    DocumentSnapshot snapShot_helper = await helpersCollection.doc(id).get();
    DocumentSnapshot snapShot_need = await userInNeedCollection.doc(id).get();
    DocumentSnapshot snapShot_admin = await adminsCollection.doc(id).get();
    DocumentSnapshot snapShot_unverfied_users = await verificationsRequestsCollection.doc(email).get();
    if (snapShot_helper.exists || snapShot_need.exists || snapShot_admin.exists ||snapShot_unverfied_users.exists ) {
      return true;
    }
    return false;
  }

  List<HelpRequest> helpRequestListFromSnapShotForSpecificVolunteer(QuerySnapshot snapshot ){

    List<HelpRequest> all_help_requests = snapshot.docs.map((doc) =>
        HelpRequest(HelpRequestType(doc['category']) ?? '', doc['description'] ?? '', DateTime.parse(doc['date']) ?? '' , doc['sender_id'] ?? '',doc['handler_id'] ?? '', getStatusFromString(doc['status'] ),doc['location'] ?? "",doc['reject_reason'] ?? "")).toList();
    List<HelpRequest> handled_or_avaible = List();
    for(var i = 0; i < all_help_requests.length; i++){
      if(all_help_requests[i].status == Status.AVAILABLE || all_help_requests[i].handler_id == this.current_vol_id){
        handled_or_avaible.add(all_help_requests[i]);
      }
    }
    return handled_or_avaible;

  }

  List<HelpRequest> helpRequestListFromSnapShotVerified(QuerySnapshot snapshot){
    List<HelpRequest> all_req_for_category =  snapshot.docs.map((doc) => HelpRequest(HelpRequestType(doc['category']) ?? '', doc['description'] ?? '', DateTime.parse(doc['date']) ?? '' , doc['sender_id'] ?? '',doc['handler_id'] ?? '', getStatusFromString(doc['status'] ),doc['location'] ?? "",doc['reject_reason'] ?? "")).toList();
    List<HelpRequest> all_req_for_category_verfied = List();
    for(var i = 0; i < all_req_for_category.length; i++){
      if(all_req_for_category[i].status == Status.AVAILABLE || all_req_for_category[i].handler_id == current_vol_id ){
        all_req_for_category_verfied.add(all_req_for_category[i]);
      }
    }
    return all_req_for_category_verfied;
  }

  Future<String> getUserAppLanguage() async{
    fb_auth.User curr_db_user = fb_auth.FirebaseAuth.instance.currentUser;
    if(curr_db_user == null){
      return "he";
    }
    String langCode;
    await usersLanguagesCollection.doc(curr_db_user.email).get().then((value) => langCode = (value.exists ? value["language"] : "he"));
    return langCode;
  }

  Future setUserAppLanguage(String userEmail, String lang) async{
    Map<String,dynamic> to_add = Map();
    to_add["language"] = lang;

    usersLanguagesCollection.doc(userEmail).set(to_add);
  }

}

Status getStatusFromString(String type){

  if (type == 'APPROVED'){
    return Status.APPROVED;
  }
  if (type == 'UNVERFIED'){
    return Status.UNVERFIED;
  }
  if (type == 'AVAILABLE'){
    return Status.AVAILABLE;
  }
  if (type == 'REJECTED'){
    return Status.REJECTED;
  }


  //assert(false);

}

Privilege getTypeFromString(String type){

  if (type == 'Admin'){
    return Privilege.Admin;
  }
  if (type == 'UserInNeed'){
    return Privilege.UserInNeed;
  }
  if (type == 'Volunteer'){
    return Privilege.Volunteer;
  }
  if (type == 'UnregisterUser'){
    return Privilege.UnregisterUser;
  }

  if (type == 'Anonymous'){
    return Privilege.Anonymous;
  }
  assert(false);

}

List<VerificationRequest> VerficationRequestListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      VerificationRequest(UnregisteredUser(doc['name'] ?? '' , doc['phoneNumber'] ?? '' , doc['email'] ?? '' , doc['sender_id'] ?? ''), getTypeFromString(doc['type'] ?? '') ,DateTime.parse(doc['date']) ?? '' , doc['birthdate'] ?? '', doc['location'] ?? '', doc['status'] ?? '', doc['work'] ?? ''
  , doc['birthplace'] ?? '', doc['spokenlangs'] ?? '', doc['firstaidcourse'] ?? ''
  , doc['mobility'] ?? '',List<HelpRequestType>())).toList();
}

List<HelpRequest> helpRequestListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      HelpRequest(HelpRequestType(doc['category']) ?? '', doc['description'] ?? '', DateTime.parse(doc['date']) ?? '' , doc['sender_id'] ?? '',doc['handler_id'] ?? '', getStatusFromString(doc['status'] ),doc['location'] ?? "",doc['reject_reason'] ?? "")).toList();
}

List<UserInquiry> UserInqurytListFromSnapShot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc) =>
  UserInquiry(doc['name'] ?? '',doc['id'] ?? '',doc['phoneNumber'] ?? '',doc['reasonForInquiry'] ?? '',doc['description'] ?? '',DateTime.parse(doc['date']) ?? '')).toList();
}







List<HelpRequestType> helpRequestTypeListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      HelpRequestType(doc['description'] ?? '')).toList();
}

List<Volunteer> VolunteerListFromSnapShot(QuerySnapshot snapshot){

  int defaultLastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
  return snapshot.docs.map((doc) =>
      Volunteer(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
  doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime, doc['stars'] ?? 0,doc['count'] ?? 0 ,doc['birthdate'] ?? ''  ,doc['location'] ?? ''  ,doc['status'] ?? ''  ,doc['work'] ?? ''  ,doc['birthplace'] ?? ''  ,doc['spokenlangs'] ?? ''  ,doc['firstaidcourse'] ?? ''  ,doc['mobility'] ?? '' ,convertCategoreisAsStringToHLT(doc['categories'] ?? []))).toList();
}

List<Admin> AdminListFromSnapShot(QuerySnapshot snapshot){

  int defaultLastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
  return snapshot.docs.map((doc) =>
      Admin(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
          doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime)).toList();
}

List<UserInNeed> UserInNeedListFromSnapShot(QuerySnapshot snapshot){
  int defaultLastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
  List<UserInNeed> all_users =  snapshot.docs.map((doc) =>
      UserInNeed( getTypeFromString(doc['privilege']), doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '' ,
  doc['id'] ?? '', doc['lastNotifiedTime'] ?? defaultLastNotifiedTime, doc['Age'] ?? 0 ,doc['Location'] ?? '' ,doc['Status'] ?? '' , doc['numKids'] ?? 0, doc['eduStatus'] ?? '', doc['homePhone'] ?? '',doc['specialStatus'] ?? '' ,doc['Rav7a'] ?? '' )).toList();
  List<UserInNeed> all_users_without_annoy = List();
  for(var i = 0; i < all_users.length; i++){
    if(all_users[i].privilege == Privilege.UserInNeed){
      all_users_without_annoy.add(all_users[i]);
    }
  }
  return all_users_without_annoy;


}


List<Organization> organizationListFromSnapShot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc) {
      List servicesString = doc['services'] ?? [];
      List<HelpRequestType> services = servicesString.map((service) => HelpRequestType(service)).toList();
      return Organization(doc['name'] ?? '', doc['phoneNumber'] ?? '', doc['email'] ?? '', doc['location'] ?? '', services);
    }
  ).toList();
}


List<HelpRequestType> convertCategoreisAsStringToHLT(List<dynamic> categoreis){
  if(categoreis==[]){
    return [];
  }
  return categoreis.map((e) => HelpRequestType(e as String)).toList();
}




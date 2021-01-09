//import 'dart:html';

//import 'dart:html';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/VerificationRequest.dart';

class DataBaseService{

  static final String user_in_need_requests = 'REQUESTS';
  static final String volunteer_pending_requests = 'PENDING_REQUESTS';
  static final String verification_requests = 'VERIFICATION_REQUESTS';


  final CollectionReference helpersCollection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference userInNeedCollection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('ADMINS');
  final CollectionReference registrationRequestsCollection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference helpRequestsTypeCollection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');
  final CollectionReference verificationsRequestsCollection = FirebaseFirestore.instance.collection(verification_requests);
  final CollectionReference allHelpsRequestsCollection = FirebaseFirestore.instance.collection('ALL_HELP_REQUESTS');
  final CollectionReference tokens = FirebaseFirestore.instance.collection('TOKENS');


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

      int newCount = snapshot.data()['count'] + 1;
      String old_stars = snapshot.data()['stars'];
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

    return await verificationsRequestsCollection.doc(verificationRequest.sender.email).set(to_add);
    
  }

  //todo : add deny verfication request

  Future DenyVerficationRequest(VerificationRequest verificationRequest){
    verificationsRequestsCollection.doc(verificationRequest.sender.email).delete();

  }
  /*/
    this function will also add the user to db and delte its request
    in case of admin or user in need catoergires are null

   */
  Future AcceptVerificationRequest(VerificationRequest verificationRequest , List<HelpRequestType> categories){

    switch (verificationRequest.type){

      case hadar.Privilege.Admin:
        Admin admin_to_add = Admin(verificationRequest.sender.name, verificationRequest.sender.phoneNumber, verificationRequest.sender.email, false, verificationRequest.sender.id);
        addAdminToDataBase(admin_to_add);
        verificationsRequestsCollection.doc(admin_to_add.email).delete();
        break;
      case hadar.Privilege.UserInNeed:
        // UserInNeed UserInNeed_to_add = UserInNeed(verificationRequest.sender.name, verificationRequest.sender.phoneNumber, verificationRequest.sender.email, false, verificationRequest.sender.id);
        // addUserInNeedToDataBase(UserInNeed_to_add);
        // verificationsRequestsCollection.doc(UserInNeed_to_add.email).delete();
        assert(false);
        break;
      case hadar.Privilege.Volunteer:
        Volunteer Volunteer_to_add = Volunteer(verificationRequest.sender.name, verificationRequest.sender.phoneNumber, verificationRequest.sender.email, false, verificationRequest.sender.id,categories,'0',0);
        addVolunteerToDataBase(Volunteer_to_add);
        verificationsRequestsCollection.doc(Volunteer_to_add.email).delete();
        break;
      case hadar.Privilege.UnregisterUser:
        assert(false);
        break;
    }

  }

  Stream<List<VerificationRequest>> getVerificationRequests() {

    return verificationsRequestsCollection.orderBy('time',descending: true)
        .snapshots()
        .map(VerficationRequestListFromSnapShot);
  }

  
  /*
  THIS FUNCTION WILL AUTOMATICALLY ADD THE REQUEST TO ALL THE RELEVANT
  VOULNTEERS -- nooooooooooo !!!
  it now add them to pending request collection
   */
  Future addHelpRequestToDataBaseForUserInNeed(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();
    to_add['time'] = helpRequest.time;
    to_add['handler_id'] = helpRequest.handler_id;
    to_add['verfied'] = helpRequest.verfied;


     userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id)
        .set(to_add).catchError((error) => print("problem in addHelpRequestToDataBaseForUserInNeed"));

     allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add);




  }

  /*/
    this function will also put the reqeust to the relvenat voulnteers
   */
  Future verify_help_request(HelpRequest helpRequest) async{

    Map<String,dynamic> to_add = Map();
    to_add['category'] = helpRequest.category.description;
    to_add['sender_id'] = helpRequest.sender_id;
    to_add['description'] = helpRequest.description;
    to_add['date'] = helpRequest.date.toString();
    to_add['time'] = helpRequest.time;
    to_add['handler_id'] = helpRequest.handler_id;
    to_add['verfied'] = true;

    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();

    helpersCollection.where('helpRequestsCategories' , arrayContains: helpRequest.category.description )
        .get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        doc.reference.collection(volunteer_pending_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).set(to_add).catchError((error) => print("failed to add for this voulnteer"));
      })
    } );

    Map<String,dynamic> to_update = Map();
    to_update['verfied'] = true;

    userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).update(to_update);



  }

  //TODO ALSO CHECK HOW TO REMOVE THE USER FROM THE AUTH
  Future cancel_help_reqeust(HelpRequest helpRequest) async {

    allHelpsRequestsCollection.doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();
    userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString()+"-"+helpRequest.sender_id).delete();

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
    to_add['count'] = user.count;
    to_add['stars'] = user.stars;
    to_add['privilege'] = user.privilege.toString().substring(10);
    to_add['helpRequestsCategories'] = user.helpRequestsCategories == null ? List(): user.helpRequestsCategories.map((e) => e.description).toList();

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
    userInNeedCollection.doc(helpRequest.sender_id).collection(user_in_need_requests).doc(helpRequest.date.toString() + "-" + helpRequest.sender_id).update(to_update);
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
          doc.data()['id'] ?? '' , get_categoreis(doc) ,doc.data()['stars'] ?? 0,doc.data()['count'] ?? 0 );
    }
  }

  Stream<List<HelpRequest>> getUserHelpRequests(hadar.User user) {

    return userInNeedCollection.doc(user.id).collection(user_in_need_requests).orderBy('time',descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  Stream<List<HelpRequest>> getAllRequests() {


    return allHelpsRequestsCollection.orderBy('time' , descending: true)
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

  Stream<List<hadar.User>> getAllUsersInNeed(){

    return userInNeedCollection
        .snapshots()
        .map(UserInNeedListFromSnapShot);
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
          doc.data()['id'] ?? '' , get_categoreis(doc) , doc.data()['stars'] ?? 0 , doc.data()['count'] ?? 0);
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

  Future get_token(String email) async{

    String token_to_return = null;
    await tokens.doc(email).get().then((value) => token_to_return = value.exists ? value.get('token') : null);
    return token_to_return;
  }

  Future add_user_token_to_db() async{

    if (CurrentUser.curr_user == null){
      return;
    }
    String token = await FirebaseMessaging().getToken();
    if(token != null){
      Map<String,dynamic> to_add = new Map();
      to_add['token'] = token;
      to_add['email'] = CurrentUser.curr_user.email;
      tokens.doc(CurrentUser.curr_user.email).set(to_add);
    }

  }

  Future Sign_out(var context) async{
    await fb_auth.FirebaseAuth.instance.signOut();

    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LogInPage(),
      ),
          (route) => false,
    );

   
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



hadar.Privilege getTypeFromString(String type){

  if (type == 'Admin'){
    return hadar.Privilege.Admin;
  }
  if (type == 'UserInNeed'){
    return hadar.Privilege.UserInNeed;
  }
  if (type == 'Volunteer'){
    return hadar.Privilege.Volunteer;
  }
  if (type == 'UnregisterUser'){
    return hadar.Privilege.UnregisterUser;
  }

  assert(false);

}

List<VerificationRequest> VerficationRequestListFromSnapShot(QuerySnapshot snapshot){
  return snapshot.docs.map((doc) =>
      VerificationRequest(UnregisteredUser(doc.data()['name'] ?? '' , doc.data()['phoneNumber'] ?? '' , doc.data()['email'] ?? '' , doc.data()['sender_id'] ?? ''), getTypeFromString(doc.data()['type'] ?? '') ,DateTime.parse(doc.data()['date']) ?? '' )).toList();
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
          doc.data()['String id'] ?? '' , get_categoreis(doc) ,doc.data()['stars'] ?? 0 , doc.data()['count'] ?? 0));
}

List<Admin> AdminListFromSnapShot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc) =>
      Admin(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? ''));
}

List<UserInNeed> UserInNeedListFromSnapShot(QuerySnapshot snapshot){

  return snapshot.docs.map((doc) =>
      UserInNeed(doc.data()['name'] ?? '', doc.data()['phoneNumber'] ?? '', doc.data()['email'] ?? '' , doc.data()['isSignedIn'] ?? false,
          doc.data()['String id'] ?? ''));
}

List<HelpRequestType> get_categoreis(DocumentSnapshot doc){

  List<HelpRequestType> categories = [];
  for (var type in doc.data()['helpRequestsCategories']){
    categories.add(HelpRequestType(type as String));
  }

  return categories;




}





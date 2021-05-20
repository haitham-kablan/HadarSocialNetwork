import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadar/services/getters/getUserName.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/UnregisteredUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/VerificationRequest.dart';

import 'DataBaseServiceMock.dart';
import 'MainMockForFirebase.dart';

const MessagesCollection = 'messages';



void main() {
  group("DB_test",(){
    test('getting user info' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();

      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);
      await dataBaseServiceMock.addVolunteerToDataBase(Volunteer('volunteer', '123', 'email@com', false , '1',"",1,",",",","","","","","",""));
      await dataBaseServiceMock.addUserInNeedToDataBase(UserInNeed(Privilege.UserInNeed,'user_in_need', '2233', 'no_need',false, '2',1,"","",2,"","","",""));
      await dataBaseServiceMock.addAdminToDataBase(Admin('admin', '2233', 'no_need',false, '3'));
      UserInNeed userInNeed = (await dataBaseServiceMock.getUserById('2', Privilege.UserInNeed) ) as UserInNeed;
      Admin admin = (await dataBaseServiceMock.getUserById('3', Privilege.Admin) ) as Admin;
      Volunteer voluntter = (await dataBaseServiceMock.getUserById('1', Privilege.Volunteer) ) as Volunteer;

      expect(userInNeed.name,equals('user_in_need'));
      expect(userInNeed.phoneNumber,equals('2233'));
      expect(userInNeed.email,equals('no_need'));
      expect(userInNeed.isSignedIn,equals(false));
      expect(userInNeed.id,equals('2'));

      expect(admin.name,equals('admin'));
      expect(admin.phoneNumber,equals('2233'));
      expect(admin.email,equals('no_need'));
      expect(admin.isSignedIn,equals(false));
      expect(admin.id,equals('3'));

      expect(voluntter.name,equals('volunteer'));
      expect(voluntter.phoneNumber,equals('123'));
      expect(voluntter.email,equals('email@com'));
      expect(voluntter.isSignedIn,equals(false));
      expect(voluntter.id,equals('1'));


    });

    test('add verifictaion request to db , returns false if we check if it is verfied' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      VerificationRequest verificationRequest = VerificationRequest(UnregisteredUser("1","1","1","1"),Privilege.Volunteer,DateTime.now(),"asd","1","1","1","1","1","1","1",List<HelpRequestType>());
      await dataBaseServiceMock.addVerficationRequestToDb(verificationRequest);
      bool is_verified = await dataBaseServiceMock.checkIfVerfied("1");

      expect(is_verified , false);

    });

    test('test veryfying verification request' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      VerificationRequest verificationRequest = VerificationRequest(UnregisteredUser("1","1","1","1"),Privilege.Volunteer,DateTime.now(),"asd","1","1","1","1","1","1","1",List<HelpRequestType>());
      await dataBaseServiceMock.addVerficationRequestToDb(verificationRequest);
      await dataBaseServiceMock.AcceptVerificationRequest(verificationRequest, List<HelpRequestType>());
      bool is_verified = await dataBaseServiceMock.checkIfVerfied("1");

      expect(is_verified , true);

    });

    test('remove user from db' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      UserInNeed userInNeed = UserInNeed(Privilege.UserInNeed, "name", "phoneNumber", "user_in_need", false, "1", 2, "Location", "Status", 1, "eduStatus", "homePhone", "specialStatus", "Rav7a");
      Admin admin = Admin("name", "phoneNumber", "ADMIN", false, "2");
      Volunteer volunteer = Volunteer("name", "phoneNumber", "3", false, "3", "2", 1, "birthdate", "location", "status", "work", "birthplace", "spokenlangs", "mobility", "");

      await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);
      await dataBaseServiceMock.addVolunteerToDataBase(volunteer);
      await dataBaseServiceMock.addAdminToDataBase(admin);

      await dataBaseServiceMock.RemoveUserfromdatabase(userInNeed);
      await dataBaseServiceMock.RemoveUserfromdatabase(volunteer);
      await dataBaseServiceMock.RemoveUserfromdatabase(admin);

      //doesnt fail
      await dataBaseServiceMock.RemoveUserfromdatabase(User("7","7","7",Privilege.Volunteer,"7"));

      User user = await dataBaseServiceMock.getUserById("1", Privilege.UserInNeed);
      User admin_ret = await dataBaseServiceMock.getUserById("2", Privilege.Admin);
      User vol = await dataBaseServiceMock.getUserById("3", Privilege.Volunteer);

      expect(user,isNull);
      expect(admin_ret,isNull);
      expect(vol,isNull);

    });


    test('remove user from db' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      UserInNeed userInNeed = UserInNeed(Privilege.UserInNeed, "name", "phoneNumber", "user_in_need", false, "1", 2, "Location", "Status", 1, "eduStatus", "homePhone", "specialStatus", "Rav7a");
      Admin admin = Admin("name", "phoneNumber", "ADMIN", false, "2");
      Volunteer volunteer = Volunteer("name", "phoneNumber", "3", false, "3", "2", 1, "birthdate", "location", "status", "work", "birthplace", "spokenlangs", "mobility", "");

      await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);
      await dataBaseServiceMock.addVolunteerToDataBase(volunteer);
      await dataBaseServiceMock.addAdminToDataBase(admin);

      await dataBaseServiceMock.RemoveUserfromdatabase(userInNeed);
      await dataBaseServiceMock.RemoveUserfromdatabase(volunteer);
      await dataBaseServiceMock.RemoveUserfromdatabase(admin);

      //doesnt fail
      await dataBaseServiceMock.RemoveUserfromdatabase(User("7","7","7",Privilege.Volunteer,"7"));

      User user = await dataBaseServiceMock.getUserById("1", Privilege.UserInNeed);
      User admin_ret = await dataBaseServiceMock.getUserById("2", Privilege.Admin);
      User vol = await dataBaseServiceMock.getUserById("3", Privilege.Volunteer);

      expect(user,isNull);
      expect(admin_ret,isNull);
      expect(vol,isNull);

    });

    test('get all unverfied requests' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      UserInNeed userInNeed = UserInNeed(Privilege.UserInNeed, "name", "phoneNumber", "user_in_need", false, "1", 2, "Location", "Status", 1, "eduStatus", "homePhone", "specialStatus", "Rav7a");
      HelpRequest helpRequest1 = HelpRequest(HelpRequestType("food"), "description", DateTime.now(), "1", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest2 = HelpRequest(HelpRequestType("food"), "description", DateTime(1990), "1", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest3 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "1", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest4 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest11 = HelpRequest(HelpRequestType("food"), "description", DateTime(1992), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest5 = HelpRequest(HelpRequestType("food"), "description", DateTime(1993), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest6 = HelpRequest(HelpRequestType("food"), "description", DateTime(1994), "2", "", Status.APPROVED, "location");
      HelpRequest helpRequest7 = HelpRequest(HelpRequestType("food"), "description", DateTime(1995), "2", "", Status.REJECTED, "location");
      HelpRequest helpRequest9 = HelpRequest(HelpRequestType("food"), "description", DateTime(1996), "2", "", Status.AVAILABLE, "location");
      await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);

      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest1);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest2);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest3);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest4);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest5);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest6);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest11);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest7);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest9);

      Stream<List<HelpRequest>> ans =  dataBaseServiceMock.getAll_unverfied_requests_Requests();
      List<HelpRequest> ans_as_list = await ans.first;
      expect(ans_as_list.length , equals(6));

    });

    test('get all available requests' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      UserInNeed userInNeed = UserInNeed(Privilege.UserInNeed, "name", "phoneNumber", "user_in_need", false, "1", 2, "Location", "Status", 1, "eduStatus", "homePhone", "specialStatus", "Rav7a");
      HelpRequest helpRequest1 = HelpRequest(HelpRequestType("food"), "description", DateTime.now(), "1", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest2 = HelpRequest(HelpRequestType("food"), "description", DateTime(1990), "1", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest3 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "1", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest4 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest11 = HelpRequest(HelpRequestType("food"), "description", DateTime(1992), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest5 = HelpRequest(HelpRequestType("food"), "description", DateTime(1993), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest6 = HelpRequest(HelpRequestType("food"), "description", DateTime(1994), "2", "", Status.APPROVED, "location");
      HelpRequest helpRequest7 = HelpRequest(HelpRequestType("food"), "description", DateTime(1995), "2", "", Status.REJECTED, "location");
      HelpRequest helpRequest9 = HelpRequest(HelpRequestType("food"), "description", DateTime(1996), "2", "", Status.UNVERFIED, "location");
      await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);

      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest1);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest2);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest3);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest4);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest5);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest6);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest11);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest7);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest9);

      Stream<List<HelpRequest>> ans =  dataBaseServiceMock.getAll_waiting_Requests();
      List<HelpRequest> ans_as_list = await ans.first;
      expect(ans_as_list.length , equals(6));

    });



    test('get all approved requests' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      UserInNeed userInNeed = UserInNeed(Privilege.UserInNeed, "name", "phoneNumber", "user_in_need", false, "1", 2, "Location", "Status", 1, "eduStatus", "homePhone", "specialStatus", "Rav7a");
      HelpRequest helpRequest1 = HelpRequest(HelpRequestType("food"), "description", DateTime.now(), "1", "", Status.APPROVED, "location");
      HelpRequest helpRequest2 = HelpRequest(HelpRequestType("food"), "description", DateTime(1990), "1", "", Status.APPROVED, "location");
      HelpRequest helpRequest3 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "1", "", Status.APPROVED, "location");
      HelpRequest helpRequest4 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "2", "", Status.APPROVED, "location");
      HelpRequest helpRequest11 = HelpRequest(HelpRequestType("food"), "description", DateTime(1992), "2", "", Status.APPROVED, "location");
      HelpRequest helpRequest5 = HelpRequest(HelpRequestType("food"), "description", DateTime(1993), "2", "", Status.APPROVED, "location");
      HelpRequest helpRequest6 = HelpRequest(HelpRequestType("food"), "description", DateTime(1994), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest7 = HelpRequest(HelpRequestType("food"), "description", DateTime(1995), "2", "", Status.REJECTED, "location");
      HelpRequest helpRequest9 = HelpRequest(HelpRequestType("food"), "description", DateTime(1996), "2", "", Status.UNVERFIED, "location");
      await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);

      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest1);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest2);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest3);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest4);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest5);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest6);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest11);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest7);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest9);

      Stream<List<HelpRequest>> ans =  dataBaseServiceMock.getAll_approved_Requests();
      List<HelpRequest> ans_as_list = await ans.first;
      expect(ans_as_list.length , equals(6));

    });

    test('get all requests for category' , () async {

      final firestore = MockFirestoreInstance();
      await firestore.clearPersistence();
      final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

      UserInNeed userInNeed = UserInNeed(Privilege.UserInNeed, "name", "phoneNumber", "user_in_need", false, "1", 2, "Location", "Status", 1, "eduStatus", "homePhone", "specialStatus", "Rav7a");
      HelpRequest helpRequest1 = HelpRequest(HelpRequestType("food"), "description", DateTime.now(), "1", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest2 = HelpRequest(HelpRequestType("food"), "description", DateTime(1990), "1", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest3 = HelpRequest(HelpRequestType("food"), "description", DateTime(1991), "1", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest4 = HelpRequest(HelpRequestType("food"), "description", DateTime(1980), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest11 = HelpRequest(HelpRequestType("food"), "description", DateTime(1992), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest5 = HelpRequest(HelpRequestType("food"), "description", DateTime(1993), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest6 = HelpRequest(HelpRequestType("food"), "description", DateTime(1994), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest7 = HelpRequest(HelpRequestType("food"), "description", DateTime(1995), "2", "", Status.AVAILABLE, "location");
      HelpRequest helpRequest9 = HelpRequest(HelpRequestType("food"), "description", DateTime(1996), "2", "3", Status.APPROVED, "location");
      HelpRequest helpRequest12 = HelpRequest(HelpRequestType("money"), "description", DateTime(1997), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest13 = HelpRequest(HelpRequestType("money"), "description", DateTime(1998), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest14 = HelpRequest(HelpRequestType("money"), "description", DateTime(1999), "2", "", Status.UNVERFIED, "location");
      HelpRequest helpRequest15 = HelpRequest(HelpRequestType("money"), "description", DateTime(2000), "2", "", Status.UNVERFIED, "location");
      await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);
      await dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType("food"));

      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest1);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest2);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest3);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest4);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest5);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest6);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest11);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest7);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest9);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest12);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest13);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest14);
      await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest15);

      Stream<List<HelpRequest>> ans =  dataBaseServiceMock.get_requests_for_category(HelpRequestType("food"), "3");
      List<HelpRequest> ans_as_list = await ans.first;
      expect(ans_as_list.length , equals(9));

    });



  });





}
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadar/services/getters/getUserName.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'DataBaseServiceMock.dart';
import 'MainMockForFirebase.dart';

const MessagesCollection = 'messages';



void main() {

  testWidgets('extracting help reqeust from db', (WidgetTester tester) async {
    // init mock db.
    final firestore = MockFirestoreInstance();
    await firestore.clearPersistence();
    expect(find.text('money'), findsNothing);
    expect(find.text('food'), findsNothing);
    final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);
    await dataBaseServiceMock.addVolunteerToDataBase(Volunteer('haitham', '123', 'email@com', false , '1', [HelpRequestType('food'),HelpRequestType('money')]));
    await dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType('food'));
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('food'), 'lots of lots of food', DateTime.now(), '123456789'));
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('food'), 'lots of lots of food', DateTime.now(), '1234567811239'));
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('money'), 'lots of lots of food', DateTime.now(), '123456789'));

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example', home: firestoremock_pending_vol_acc_reqeusts(firestore,false)));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('food'), findsNWidgets(2));
    expect(find.text('money'), findsNWidgets(1));


  });


  test('getting user info' , () async {

    final firestore = MockFirestoreInstance();
    await firestore.clearPersistence();
    final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);
    await dataBaseServiceMock.addVolunteerToDataBase(Volunteer('volunteer', '123', 'email@com', false , '1', [HelpRequestType('food'),HelpRequestType('money')]));
    await dataBaseServiceMock.addUserInNeedToDataBase(UserInNeed('user_in_need', '2233', 'no_need',false, '2'));
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
    expect(voluntter.helpRequestsCategories[0].description,equals(HelpRequestType('food').description));
    expect(voluntter.helpRequestsCategories[1].description,equals(HelpRequestType('money').description));



  });

  testWidgets('assign volunteer for specific request', (WidgetTester tester) async {

    Volunteer volunteer = Volunteer('haitham', '123', 'email@com', false , '1', [HelpRequestType('food'),HelpRequestType('money')]);
    HelpRequest helpRequest = HelpRequest(HelpRequestType('food'), 'lots of lots of food', DateTime.now(), '123456789');
    // init mock db.
    final firestore = MockFirestoreInstance();
    await firestore.clearPersistence();
    final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);
    await dataBaseServiceMock.addVolunteerToDataBase(volunteer);
    await dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType('food'));
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest);
    await dataBaseServiceMock.assignHelpRequestForVolunteer(volunteer, helpRequest);

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example', home: firestoremock_pending_vol_acc_reqeusts(firestore,true)));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('food'), findsNWidgets(1));
    expect(find.text('lots of lots of food'), findsNWidgets(1));

    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example', home: firestoremock_pending_vol_acc_reqeusts(firestore,false)));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('food'), findsNothing);
    expect(find.text('lots of lots of food'), findsNothing);


  });


  testWidgets('get user name', (WidgetTester tester) async {

    Volunteer volunteer = Volunteer('haitham', '123', 'email@com', false , '1', [HelpRequestType('food'),HelpRequestType('money')]);
    // init mock db.
    final firestore = MockFirestoreInstance();
    await firestore.clearPersistence();
    final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);
    await dataBaseServiceMock.addVolunteerToDataBase(volunteer);

    // Render the widget.
    await tester.pumpWidget(MaterialApp(
        title: 'Firestore Example', home: GetUserName('1',firestore.collection('HELPERS'))));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('haitham'), findsNWidgets(1));



  });




}
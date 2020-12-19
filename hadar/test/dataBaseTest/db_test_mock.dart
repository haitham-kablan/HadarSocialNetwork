import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import 'DataBaseServiceMock.dart';

class db_test_mock extends StatelessWidget {
  FirebaseFirestore firebaseFirestore;
  DataBaseServiceMock dataBaseServiceMock;
  db_test_mock(FirebaseFirestore instance){
    firebaseFirestore=instance;
    dataBaseServiceMock = DataBaseServiceMock(instance);
  }
  DateTime date ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('db_test'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text('add user in need'),
              onPressed: (){
                dataBaseServiceMock.addUserInNeedToDataBase(User('haitham', '2233', 'no_need', Privilege.UserInNeed, '123456789'));
                dataBaseServiceMock.addUserInNeedToDataBase(User('s3ed', '2233', 'no_need', Privilege.UserInNeed, '2'));
                dataBaseServiceMock.addUserInNeedToDataBase(User('lbed', '2233', 'no_need', Privilege.UserInNeed, '3'));
              },
            ),
            RaisedButton(
              child: Text('add volunteer'),
              onPressed: (){
                List<HelpRequestType> list1 = new List<HelpRequestType>();
                list1.add(HelpRequestType('food'));
                list1.add(HelpRequestType('money'));
                dataBaseServiceMock.addVolunteerToDataBase(Volunteer('hsen', 'sa', '123', false, '4', list1));
                list1.add(HelpRequestType('fighting'));
                dataBaseServiceMock.addVolunteerToDataBase(Volunteer('lolly', 'sa', '123', false, '5', list1));
              },
            ),
            RaisedButton(
              child: Text('add admin'),
              onPressed: (){
                dataBaseServiceMock.addAdminToDataBase(Admin('numbeer_1', 'twel', '@@', false, '6'));
              },
            ),
            RaisedButton(
              child: Text('add help request type'),
              onPressed: (){
                dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType('food'));
                dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType('money'));
                dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType('fighting'));
                dataBaseServiceMock.addHelpRequestTypeDataBase(HelpRequestType('babysit'));
              },
            ),
            RaisedButton(
              child: Text('add help request'),
              onPressed: (){
                date = DateTime.now();
                dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('food'), 'lots of lots of food', date, '123456789',''));
                dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('food'), 'lots of lots of food but more', DateTime.now(), '123456789',''));
                dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('money'), 'lots of lots of money', date, '2',''));
                dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('fighting'), 'lots of lots of fights', date, '3',''));

              },
            ),
            RaisedButton(
              child: Text('assign voulnteer for request'),
              onPressed: (){
                List<HelpRequestType> list1 = List<HelpRequestType>();
                list1.add(HelpRequestType('food'));
                list1.add(HelpRequestType('money'));
                dataBaseServiceMock.assignHelpRequestForVolunteer(Volunteer('hsen', 'sa', '123', false, '4', list1), HelpRequest(HelpRequestType('food'), 'lots of lots of food', date, '123456789',''));
                dataBaseServiceMock.assignHelpRequestForVolunteer(Volunteer('lolly', 'sa', '123', false, '5', list1), HelpRequest(HelpRequestType('money'), 'lots of lots of money',date, '2',''));


              },
            ),
            RaisedButton(
              child: Text('get user help request'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => testing_stream(dataBaseServiceMock)),
                );
              },
            ),
            RaisedButton(
              child: Text('get all voulnteers for specif request'),
              onPressed: (){

              },

            ),
            RaisedButton(
              child: Text('get help request as a list'),
              onPressed: () async {
                List<HelpRequestType> x = await dataBaseServiceMock
                    .helpRequestAsAlist();

                print_list(x);
              },
            ),
            RaisedButton(
              child: Text('get user by id'),
              onPressed: () async {
                UserInNeed userInNeed = (await dataBaseServiceMock.getUserById("123456789", Privilege.UserInNeed)) as UserInNeed;
                print("printing user");
                if (userInNeed == null){
                  print('got null');
                }else {
                  print(userInNeed.name);
                  print(userInNeed.id);
                  print(userInNeed.phoneNumber);
                }
              },
            ),
          ],
        ),
      ),

    );
  }
}

class testing_stream extends StatelessWidget {

  DataBaseServiceMock dataBaseServiceMock;
  testing_stream(this.dataBaseServiceMock);

  @override
  Widget build(BuildContext context) {
    List<HelpRequestType> list1 = List<HelpRequestType>();
    list1.add(HelpRequestType('food'));
    list1.add(HelpRequestType('money'));
    return StreamProvider<List<HelpRequest>>.value(
      value: dataBaseServiceMock.getVolPendingRequests(Volunteer('hsen', 'sa', '123', false, '4', list1)),
      child: Scaffold(
        backgroundColor: Colors.brown[50],

        appBar: AppBar(
          title: Text('Volunteer Feed'),
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: HelperFeed(),
      ),
    );
  }
}


void print_list(List<HelpRequestType> s){

  for(int i = 0 ; i < s.length ; i++){
    print(s[i].description);
  }

}
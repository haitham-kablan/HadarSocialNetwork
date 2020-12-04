import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

class db_test extends StatelessWidget {
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
                DataBaseService().addUserInNeedToDataBase(User('haitham', '2233', 'no_need', Privilege.UserInNeed, '1'));
                DataBaseService().addUserInNeedToDataBase(User('s3ed', '2233', 'no_need', Privilege.UserInNeed, '2'));
                DataBaseService().addUserInNeedToDataBase(User('lbed', '2233', 'no_need', Privilege.UserInNeed, '3'));
              },
            ),
            RaisedButton(
              child: Text('add volunteer'),
              onPressed: (){
                List<HelpRequestType> list1 = new List<HelpRequestType>();
                list1.add(HelpRequestType('food'));
                list1.add(HelpRequestType('money'));
                DataBaseService().addVolunteerToDataBase(Volunteer('hsen', 'sa', '123', false, '4', list1));
                list1.add(HelpRequestType('fighting'));
                DataBaseService().addVolunteerToDataBase(Volunteer('lolly', 'sa', '123', false, '5', list1));
              },
            ),
            RaisedButton(
              child: Text('add admin'),
              onPressed: (){
                DataBaseService().addAdminToDataBase(Admin('numbeer_1', 'twel', '@@', false, '6'));
              },
            ),
            RaisedButton(
              child: Text('add help request type'),
              onPressed: (){
                DataBaseService().addHelpRequestTypeDataBase(HelpRequestType('food'));
                DataBaseService().addHelpRequestTypeDataBase(HelpRequestType('money'));
                DataBaseService().addHelpRequestTypeDataBase(HelpRequestType('fighting'));
                DataBaseService().addHelpRequestTypeDataBase(HelpRequestType('babysit'));
              },
            ),
            RaisedButton(
              child: Text('add help request'),
              onPressed: (){
                DataBaseService().addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('food'), 'lots of lots of food', DateTime.now(), '1'));
                DataBaseService().addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('food'), 'lots of lots of food but more', DateTime.now(), '1'));
                DataBaseService().addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('money'), 'lots of lots of money', DateTime.now(), '2'));
                DataBaseService().addHelpRequestToDataBaseForUserInNeed(HelpRequest(HelpRequestType('fighting'), 'lots of lots of fights', DateTime.now(), '3'));

              },
            ),
            RaisedButton(
              child: Text('assign voulnteer for request'),
              onPressed: (){
                List<HelpRequestType> list1 = List<HelpRequestType>();
                list1.add(HelpRequestType('food'));
                list1.add(HelpRequestType('money'));
                DataBaseService().assignHelpRequestForVolunteer(Volunteer('hsen', 'sa', '123', false, '4', list1), HelpRequest(HelpRequestType('food'), 'lots of lots of food', DateTime.now(), '1'));
                DataBaseService().assignHelpRequestForVolunteer(Volunteer('lolly', 'sa', '123', false, '5', list1), HelpRequest(HelpRequestType('money'), 'lots of lots of money', DateTime.now(), '2'));


              },
            ),
            RaisedButton(
              child: Text('get user help request'),
              onPressed: (){
                print('getting user help request');
                print(DataBaseService().getUserHelpRequests(User('haitham', '2233', 'no_need', Privilege.UserInNeed, '1')));
              },
            ),
            RaisedButton(
              child: Text('get all voulnteers for specif request'),
              onPressed: (){

              },
            ),
            RaisedButton(
              child: Text('get vol help request'),
              onPressed: (){

              },
            ),
            RaisedButton(
              child: Text('get help request types'),
              onPressed: (){

              },
            ),
          ],
        ),
      ),

    );
  }
}

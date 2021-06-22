import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/Buttons/RoundedWeightedButtons.dart';
import 'package:hadar/Design/basicTools.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/users/RegisteredUser.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import 'package:hadar/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'DataBaseServiceMock.dart';
import 'db_test_mock.dart';


class firestoremock_pending_vol_acc_reqeusts extends StatelessWidget {

  FirebaseFirestore instance;
  bool accepted;
  firestoremock_pending_vol_acc_reqeusts(this.instance,this.accepted);

  @override
  Widget build(BuildContext context) {
    return testing_stream(instance,accepted);
  }
}

class testing_stream extends StatelessWidget {

  FirebaseFirestore dataBaseServiceMock;
  static final String volunteer_pending_requests = 'PENDING_REQUESTS';
  static final String volunteer_accepted_requests = 'ACCEPTED_REQUESTS';
  CollectionReference helpersCollection;
  bool accepted;

  testing_stream(this.dataBaseServiceMock,this.accepted){
    helpersCollection = dataBaseServiceMock.collection('HELPERS');
  }

  @override
  Widget build(BuildContext context) {
    List<HelpRequestType> list1 = List<HelpRequestType>();
    list1.add(HelpRequestType('food'));
    int lastNotifiedTime = DateTime.now().millisecondsSinceEpoch;
    Volunteer vol = Volunteer('haitham', '123', 'email@com', '1', lastNotifiedTime, "stars", 2, "birthdate", "location", "status", "work", "birthplace", "spokenlangs", "mobility", "firstaidcourse",[]);


    return StreamProvider<List<HelpRequest>>.value(
      value: accepted ? getVolAceeptedRequests(vol) : getVolPendingRequests(vol),
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

  Stream<List<HelpRequest>> getVolPendingRequests(Volunteer volunteer) {

    return helpersCollection.doc(volunteer.id).collection(volunteer_pending_requests).orderBy('time',descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);
  }

  List<HelpRequest> helpRequestListFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) =>
        HelpRequest(HelpRequestType(doc['category']) ?? '', doc['description'] ?? '', DateTime.parse(doc['date']) ?? '' , doc['sender_id'] ?? '',doc['handler_id'] ?? '', getStatusFromString(doc['status'] ),doc['location'] ?? "",doc['reject_reason'] ?? "")).toList();
  }

  Stream<List<HelpRequest>> getVolAceeptedRequests(Volunteer volunteer) {

    return helpersCollection.doc(volunteer.id).collection(volunteer_accepted_requests).orderBy('time',descending: true)
        .snapshots()
        .map(helpRequestListFromSnapShot);
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataBaseService{


  final CollectionReference Helpers_collection = FirebaseFirestore.instance.collection('HELPERS');
  final CollectionReference Usesr_in_need_collection = FirebaseFirestore.instance.collection('USERS_IN_NEED');
  final CollectionReference Registeration_requests_collection = FirebaseFirestore.instance.collection('REGISTRATION_REQUESTS');
  final CollectionReference Help_requests_type_collection = FirebaseFirestore.instance.collection('HELP_REQUESTS_TYPES');
  final CollectionReference Help_requests_collection = FirebaseFirestore.instance.collection('HELP_REQUESTS');


  Stream<QuerySnapshot> get Helpers{
    return Helpers_collection.snapshots();
  }

  Stream<QuerySnapshot> get Usesr_in_need{
    return Usesr_in_need_collection.snapshots();
  }

  Stream<QuerySnapshot> get Registeration_requests{
    return Registeration_requests_collection.snapshots();
  }

  Stream<QuerySnapshot> get Help_requests_type{
    return Help_requests_type_collection.snapshots();
  }

  Stream<QuerySnapshot> get Help_requests{
    return Help_requests_collection.snapshots();
  }
}







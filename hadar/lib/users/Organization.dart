import 'dart:core';

import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import '../utils/HelpRequest.dart';
import 'Privilege.dart';
import 'RegisteredUser.dart';

class Organization extends RegisteredUser {
  List<HelpRequest> helpRequests;
  String location;
  List<HelpRequestType> services;

  Organization(String name, String phoneNumber, String email, bool isSignedIn,
      String id, String location, List<HelpRequestType> services)
      : this.location = location, this.services = services,
        super(
            name, phoneNumber, email, Privilege.Organization, isSignedIn, id) {
    helpRequests = new List<HelpRequest>();
  }
}

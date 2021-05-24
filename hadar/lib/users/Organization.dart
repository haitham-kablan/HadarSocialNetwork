import 'dart:core';

import 'package:hadar/utils/HelpRequestType.dart';


class Organization {
  String name;
  String phoneNumber;
  String email;
  String location;
  List<HelpRequestType> services;

  Organization(this.name, this.phoneNumber, this.email, this.location,
      this.services);

}

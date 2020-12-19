

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Volunteer.dart';

import 'User.dart';

class CurrentUser{

  static User curr_user;

  static Future init_user() async{
    curr_user = await DataBaseService().getCurrentUser();

  }
}


import 'package:hadar/main_pages/AdminPage.dart';
import 'package:hadar/main_pages/UserInNeedPage.dart';
import 'package:hadar/main_pages/VolunteerPage.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';

import 'User.dart';

class CurrentUser{

  static User curr_user;

  static Future init_user() async{
    curr_user = await DataBaseService().getCurrentUser();
    switch(curr_user.privilege){

      case Privilege.Admin:
        return AdminPage(curr_user as Admin);
        break;
      case Privilege.UserInNeed:
        return UserInNeedPage(curr_user as UserInNeed);
        break;
      case Privilege.Volunteer:
        return VolunteerPage(curr_user as Volunteer);
        break;
      case Privilege.UnregisterUser:
        print('error in curr user');
        break;
      default:
        print('error in curr user');
        break;
    }

  }
}
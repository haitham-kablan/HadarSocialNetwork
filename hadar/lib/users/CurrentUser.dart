

import 'package:hadar/feeds/Admin_JoinRequest_Feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:hadar/feeds/feed_items/category_scrol.dart';

import 'package:hadar/main_pages/AdminPage.dart';
import 'package:hadar/main_pages/UserInNeedPage.dart';
import 'package:hadar/main_pages/VolunteerPage.dart';
import 'package:hadar/profile.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/users/Volunteer.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:hadar/utils/VerificationRequest.dart';
import 'package:provider/provider.dart';

import 'User.dart';

class CurrentUser{

  static User curr_user = null;

  User getCurrent() {
    return curr_user;
  }

  static Future init_user() async{
    curr_user = await DataBaseService().getCurrentUser();
    List<HelpRequestType> categoers = await DataBaseService().helpRequestAsAlist();
    List<MyListView> categoers_list_items = List();
    for(var i = 0; i < categoers.length; i++){
      categoers_list_items.add(MyListView(categoers[i].description));
    }
    categoers_list_items.add(MyListView('אחר'));
    if(curr_user == null){
      return null;
    }
    switch(curr_user.privilege){

      case Privilege.Admin:
        return AdminPage(curr_user as Admin);
        break;
      case Privilege.UserInNeed:
        return UserInNeedPage(curr_user as UserInNeed);
        break;
      case Privilege.Volunteer:
        return VolunteerPage(curr_user as Volunteer , categoers_list_items);
        break;
      case Privilege.UnregisterUser:
        print('error in curr user');
        break;
      default:
        print('error in curr user');
        break;
    }


  }

  // static Widget get_current_user_page(User curr_user) async{
  //   List<HelpRequestType> categoers = await DataBaseService().helpRequestAsAlist();
  //   List<MyListView> categoers_list_items;
  //   for(var i = 0; i < categoers.length; i++){
  //     categoers_list_items.add(MyListView(categoers[i].description));
  //   }
  //
  //   print(curr_user);
  //   switch(curr_user.privilege){
  //
  //     case Privilege.Admin:
  //       return AdminPage(curr_user as Admin);
  //       break;
  //     case Privilege.UserInNeed:
  //       return UserInNeedPage(curr_user as UserInNeed);
  //       break;
  //     case Privilege.Volunteer:
  //       return VolunteerPage(curr_user as Volunteer , categoers_list_items);
  //       break;
  //     case Privilege.UnregisterUser:
  //       print('error in curr user');
  //       break;
  //     default:
  //       print('error in curr user');
  //       break;
  //   }
  //
  //
  // }
}

import 'package:flutter/material.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/User.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:provider/provider.dart';

import '../feeds/user_inneed_feed.dart';


class UserInNeedPage extends StatelessWidget {

  final UserInNeed curr_user;
  UserInNeedPage(this.curr_user);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HelpRequest>>.value(
      value: DataBaseService().getUserHelpRequests(curr_user),
      child: UserInNeedHelpRequestsFeed(),
    );
  }
}

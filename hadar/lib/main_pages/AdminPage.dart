import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadar/feeds/AdminVerifiedHelpRequestsFeed.dart';

import 'package:hadar/feeds/Admin_JoinRequest_Feed.dart';

import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/mainDesign.dart';
import 'package:hadar/feeds/adminfeedtile.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/feeds/helper_feed.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/VerificationRequest.dart';
import 'package:provider/provider.dart';

import '../feeds/viewRegisteredUsers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPage extends StatelessWidget {
  final Admin curr_user;

  AdminPage(this.curr_user);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: AdminBottomBar(),
      backgroundColor: BasicColor.backgroundClr,
      body: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    adminViewRequestsBar(AppLocalizations.of(context).requests),
                    new SliverPadding(
                      padding: new EdgeInsets.all(2.0),
                      sliver: new SliverList(
                        delegate: new SliverChildListDelegate([
                          TabBar(
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              new Tab(
                                  icon: Icon(Icons.account_circle_outlined,
                                  size: 25),
                                  text: AppLocalizations.of(context).joinRequests
                              ),
                              new Tab(
                                  icon: Icon(Icons.supervisor_account_sharp,
                                  size: 25),
                                  text: AppLocalizations.of(context).waitingRequests
                              ),
                              new Tab(
                                  icon: Icon(Icons.verified_user_outlined,
                                      size: 25),
                                  text: AppLocalizations.of(context).approvedRequests
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    Center(
                      child: AdminJoinRequestsFeed(curr_user),
                    ),
                    Center(
                      child: AdminHelpRequestsFeed(curr_user,Status.UNVERFIED),
                    ),
                    Center(
                      child:
                      //Center(child: Text('asd'),)
                      AdminVerifiedHelpRequestsFeed(curr_user,Status.APPROVED),

                    ),
                  ],
                ),
                // Center(

              ),
            ),
      );

      /*return Scaffold(
        appBar: AppBar(
          title: Text('Admin page'),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Column(
                children: [
                  Icon(Icons.admin_panel_settings_outlined , size: 40,),
                  RaisedButton(
                    child: Text('sign out'),
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('All requests'),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminHelpRequestsFeed(curr_user)),
                      );
                    }
                  ),
                  RaisedButton(
                      child:Text('join requests'), onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StreamProvider<List<VerificationRequest>>.value(
                            value: DataBaseService().getVerificationRequests(),
                            child: AdminJoinRequestsFeed(admin: curr_user,),),
                    )
                    );
                  }),
                  RaisedButton(
                      child:Text('allUsers'), onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllUsersView()
                        )
                    );
                  }),
                ],
            ),
          ),
        ),
      );*/
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import '../helper_feed.dart';
import '../OrganizationFeed.dart';


class father_state{
  static _StatefulCategoriesListState father = null;
}





class MyListView extends StatelessWidget {

  String Help_request_type;

  MyListView(this.Help_request_type );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Center(
        child: ListTile(
          title: Text(Help_request_type , style: TextStyle(color: BasicColor.clr , fontWeight: FontWeight.bold),),
          onTap: (){
         father_state.father.setState(() {
           father_state.father.provider = DataBaseService().get_requests_for_category(HelpRequestType(Help_request_type),CurrentUser.curr_user.id);
           father_state.father.category = Help_request_type;
         });
         if(CurrentUser.curr_user.privilege == Privilege.Volunteer) {
           volunteer_feed_pafe_state.state.setState(() {
             volunteer_feed_pafe_state.state.title = Help_request_type;
           });
         }
         else if(CurrentUser.curr_user.privilege == Privilege.Organization) {
           organization_feed_pafe_state.state.setState(() {
             organization_feed_pafe_state.state.title = Help_request_type;
           });
         }

          },
        ),
      ),
    );
  }
}

class StatefulCategoriesList extends StatefulWidget {
  List<MyListView> categories;
  var provider;
  String category;
  StatefulCategoriesList(this.categories,this.provider , this.category);
  @override
  _StatefulCategoriesListState createState() => _StatefulCategoriesListState(categories,provider,category);
}

class _StatefulCategoriesListState extends State<StatefulCategoriesList> {

  List<MyListView> categories;
  var provider;
  String category;
  _StatefulCategoriesListState(this.categories,this.provider,this.category);
  @override
  Widget build(BuildContext context) {
    father_state.father = this;
    return  StreamProvider<List<HelpRequest>>.value(
      value: provider,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 2),
            child: Column(
              children: [
                //Container(height: 1,color: BasicColor.clr,),
                Container(
                  height: 60,
                  margin: EdgeInsets.all(5),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories,
                  ),
                ),
                Container(height: 1,color: BasicColor.clr,),
              ],
            ),
          ),
         // Container(margin: EdgeInsets.only(top: 20),child: Text(category,style: TextStyle(fontSize: 25,color: BasicColor.clr,fontWeight: FontWeight.bold),),),
          Expanded(child: HelperFeed())
        ],


      ),);
  }
}

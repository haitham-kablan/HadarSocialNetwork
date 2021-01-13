import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import '../helper_feed.dart';

class tap_colors{
  static List<Colors> tap_colors_list = List();
}
class father_state{
  static _StateFullCategoreisListState father = null;
}


class MyListViewStatefull extends StatefulWidget {

  String Help_request_type;
  Color color;
  int index;
  MyListViewStatefull(this.Help_request_type, this.color , this.index);
  _MyListViewStatefullState son_state;

  @override
  _MyListViewStatefullState createState(){
    son_state = _MyListViewStatefullState(Help_request_type,color,index);

  }

  void update_color(){
    son_state.setState(() {
      color = BasicColor.backgroundClr;
    });
  }

}

class _MyListViewStatefullState extends State<MyListViewStatefull> {

  String Help_request_type;
  Color color;
  int index;
  _MyListViewStatefullState(this.Help_request_type, this.color,this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.color,
      width: 120,
      child: Center(
        child: ListTile(
          title: Text(Help_request_type , style: TextStyle(color: BasicColor.clr , fontWeight: FontWeight.bold),),
          onTap: (){
           setState(() {
             color = Colors.white;
           });
           for (int i =0 ; i < CurrentUser.categoers_list_items.length ; i++){
             if(i != index){
               CurrentUser.categoers_list_items[i].update_color();
             }
           }

            father_state.father.setState(() {
              father_state.father.provider = DataBaseService().get_requests_for_category(HelpRequestType(Help_request_type),CurrentUser.curr_user.id);
            });

          },
        ),
      ),
    );
  }
}


class StateFullCategoreisList extends StatefulWidget {

  var provider;
  StateFullCategoreisList(this.provider);
  @override
  _StateFullCategoreisListState createState() => _StateFullCategoreisListState(provider);
}

class _StateFullCategoreisListState extends State<StateFullCategoreisList> {


  var provider;
  _StateFullCategoreisListState(this.provider);
  @override
  Widget build(BuildContext context) {
    father_state.father = this;
    return  StreamProvider<List<HelpRequest>>.value(
      value: provider,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                Container(height: 1,color: BasicColor.clr,),
                Container(
                  height: 60,
                  margin: EdgeInsets.all(10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: CurrentUser.categoers_list_items,
                  ),
                ),
                Container(height: 1,color: BasicColor.clr,),
              ],
            ),
          ),
          Expanded(child: HelperFeed())
        ],


      ),);
  }
}

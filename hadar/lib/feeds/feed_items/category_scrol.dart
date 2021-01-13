import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import '../helper_feed.dart';
class Categories_list extends StatelessWidget {

  List<MyListView> categores;

  Categories_list(this.categores);
  @override
  Widget build(BuildContext context) {
    return Column(
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
              children: categores,
            ),
          ),
              Container(height: 1,color: BasicColor.clr,),
            ],
          ),
        ),
        Expanded(child: HelperFeed())
      ],
    );
  }
}

class MyListView extends StatelessWidget {

  String Help_request_type;
  MyListView(this.Help_request_type);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Center(
        child: ListTile(
          title: Text(Help_request_type , style: TextStyle(color: BasicColor.clr , fontWeight: FontWeight.bold),),
          onTap: (){


          },
        ),
      ),
    );
  }
}

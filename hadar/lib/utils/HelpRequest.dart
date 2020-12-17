
import 'package:hadar/utils/HelpRequestType.dart';

import 'HelpRequestType.dart';

class HelpRequest{

  HelpRequestType category;
  String description;
  DateTime date;
  String sender_id;
  String handler_id;
  static int indexer = 0;
  int time;
  HelpRequest( this.category, this.description, this.date , this.sender_id,this.handler_id){
    time = date.millisecondsSinceEpoch;
  }
  //DateTime date;


  //HelpRequest(this.sender, this.category, this.description, this.date);
  HelpRequest.fake():
        sender_id = "slim shady" + (indexer++).toString(),
        category = HelpRequestType("food"),
        description = "i need someone to peel some potatoes for me",
        date = DateTime.now();

  //todo: should add information about people who offered help and the status of the request

}
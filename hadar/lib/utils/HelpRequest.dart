
import 'package:hadar/utils/HelpRequestType.dart';

import 'HelpRequestType.dart';

enum Status {AVAILABLE , UNVERFIED , APPROVED , REJECTED}
class HelpRequest{

  HelpRequestType category;
  String description;
  DateTime date;
  String sender_id;
  String handler_id;
  static int indexer = 0;
  int time;
  Status status;
  String reject_reason;
  String location;
  HelpRequest( this.category, this.description, this.date , this.sender_id,this.handler_id,this.status , this.location,[String rejext_reason = '']){
    time = date.millisecondsSinceEpoch;
    reject_reason = rejext_reason;
  }
  //DateTime date;

  //copy constructor.. but change the date to DateTime.now()
  HelpRequest.copy(HelpRequest other):
      category = other.category,
      description = other.description,
      date = DateTime.now(),
      sender_id = other.sender_id;


  //HelpRequest(this.sender, this.category, this.description, this.date);
  HelpRequest.fake():
        sender_id = "slim shady" + (indexer++).toString(),
        category = HelpRequestType("food"),
        description = "i need someone to peel some potatoes for me",
        date = DateTime.now();

  //todo: should add information about people who offered help and the status of the request

}
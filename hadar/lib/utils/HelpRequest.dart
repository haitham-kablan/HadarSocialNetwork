
import 'package:hadar/utils/HelpRequestType.dart';

import 'HelpRequestType.dart';

class HelpRequest{

  String category;
  String description;
  String date;
  String sender;
  static int indexer = 0;
  HelpRequest( this.category, this.description, this.date , this.sender);
  //DateTime date;


  //HelpRequest(this.sender, this.category, this.description, this.date);
  HelpRequest.fake():
        sender = "slim shady" + (indexer++).toString(),
        category = "food",
        description = "i need someone to peel some potatoes for me",
        date = DateTime.now().toString();

  //todo: should add information about people who offered help and the status of the request

}
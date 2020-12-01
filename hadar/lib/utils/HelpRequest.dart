
import 'package:hadar/utils/HelpRequestType.dart';

class HelpRequest{

  String category;
  String description;

  String date;
  String sender;

  HelpRequest( this.category, this.description, this.date , this.sender);
  DateTime date;
  static int indexer = 0;

  HelpRequest(this.sender, this.category, this.description, this.date);
  HelpRequest.fake():
        sender = "slim shady" + (indexer++).toString(),
        category = HelpRequestType("food"),
        description = "i need someone to peel some potatoes for me",
        date = DateTime.now();

  //todo: should add information about people who offered help and the status of the request

}

import 'package:hadar/utils/HelpRequestType.dart';

class HelpRequest{
  String sender;
  HelpRequestType category;
  String description;
  DateTime date;

  HelpRequest(this.sender, this.category, this.description, this.date);
}
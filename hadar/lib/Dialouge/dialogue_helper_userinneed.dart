
import 'package:flutter/material.dart';


import 'help_request_reject_reasn_dalouge.dart';

class DialogHelpRequestHelper {

  static exit(context,help_request) => showDialog(context: context, builder: (context) => shoReject_Reason(help_request));
}
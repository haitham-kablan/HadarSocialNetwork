
import 'package:flutter/material.dart';

import 'admin_reject_reqeust_dialogue.dart';

class DialogHelper {

  static exit(context,help_request) => showDialog(context: context, builder: (context) => ExitConfirmationDialog(help_request));
}
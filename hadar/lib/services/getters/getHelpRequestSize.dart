

import 'package:flutter/cupertino.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import '../DataBaseServices.dart';

class getHelpRequestTypeSize extends StatelessWidget {
  final HelpRequestType helpRequestType;
  final String vol_id;

  getHelpRequestTypeSize(this.helpRequestType,this.vol_id);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<int>(
      future: DataBaseService().getSizeOfHelpReqType(helpRequestType,vol_id),
      builder:
          (BuildContext context, AsyncSnapshot<int> snapshot) {

        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Text("("+snapshot.data.toString()+")" , style: TextStyle(color: BasicColor.clr),);
        }
        return  Text("...");
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class shoReject_Reason extends StatelessWidget {

  final reason_reject = TextEditingController();
  final HelpRequest help_request;

  shoReject_Reason( this.help_request);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(

    height: 350,
    decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/sad.png', height: 120, width: 120,),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
        SizedBox(height: 24,),
        
        Container(padding : EdgeInsets.all(15),child: Text(help_request.reject_reason, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 8,),
            RaisedButton(onPressed: (){
              DataBaseService().delete_help_reqeust(help_request);
              return Navigator.of(context).pop(true);
            }, child: Text(AppLocalizations.of(context).deleteRequest), color: Colors.white, textColor: Colors.redAccent,)
          ],
        )
      ],
    ),
  );
}
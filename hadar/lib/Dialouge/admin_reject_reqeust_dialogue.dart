import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExitConfirmationDialog extends StatelessWidget {

  final reason_reject = TextEditingController();
  final HelpRequest help_request;

  ExitConfirmationDialog( this.help_request);

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
        Text(AppLocalizations.of(context).reqeustRejectReason, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),

            textAlign: TextAlign.end,
            controller: reason_reject,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintStyle: TextStyle(
                color: Colors.white,
              ),
              hintText: AppLocalizations.of(context).rejectReason,


            ),
          ),
        ),
        SizedBox(height: 24,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 8,),
            RaisedButton(onPressed: (){
              print(reason_reject.text);
              help_request.reject_reason = reason_reject.text.isEmpty ? AppLocalizations.of(context).adminDidntDescribeRejection : reason_reject.text;
              DataBaseService().cancel_help_reqeust(help_request);
              return Navigator.of(context).pop(true);
            }, child: Text(AppLocalizations.of(context).send), color: Colors.white, textColor: Colors.redAccent,)
          ],
        )
      ],
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Dialouge/admin_reject_reqeust_dialogue.dart';
import 'package:hadar/Dialouge/dialogue_helper_admin.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/utils/HelpRequest.dart';
import 'package:marquee/marquee.dart';


import 'Design/basicTools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void HelpRequestAdminDialuge(context,HelpRequest helpRequest){

  showModalBottomSheet(context: context, builder: (BuildContext bc){
    return  Container(
        color: Color(0xFF696969),
        height: MediaQuery.of(context).size.height /1.5,
        child: Container(
          decoration:  BoxDecoration(
            color: BasicColor.backgroundClr,
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(20),
              topLeft: const Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Directionality(
          textDirection: TextDirection.rtl,
          child:Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(AppLocalizations.of(context).requestDescription , style: TextStyle(
                  fontSize: 30,
                  color: BasicColor.clr,fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child:Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    helpRequest.date.toString().substring(0,16),
                    style: TextStyle(
                      fontSize: 14,
                      color: BasicColor.clr,
                      fontFamily: "Arial",
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5,right: 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).userInNeedTwoDots ,
                      style: TextStyle(fontSize: 18 , color: BasicColor.clr ,),
                    ),
                    Container(margin: EdgeInsets.only(right: 10),),
                    Text(helpRequest.sender_id ,style: TextStyle(fontSize: 18),textDirection: TextDirection.rtl, ),

                  ],
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 2,right: 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).categoryTwoDots ,
                      style: TextStyle(fontSize: 18 , color: BasicColor.clr ,),
                    ),
                    Container(margin: EdgeInsets.only(right: 10),),
                    Text(helpRequest.category.description ,style: TextStyle(fontSize: 18),textDirection: TextDirection.rtl, ),
                  ],
                ),
              ),

              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 2,right: 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Container(margin: EdgeInsets.only(right: 10),),
                    Text(
                      AppLocalizations.of(context).requestDescription ,
                      style: TextStyle(fontSize: 18 , color: BasicColor.clr , ),
                    ),


                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(helpRequest.description),
                  ),
                 )
              ),
              Container(
                margin: EdgeInsets.all(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    margin: EdgeInsets.all(10),

                    child: RaisedButton(
                      color: BasicColor.clr,
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      onPressed: () async {
                        await DialogHelper.exit(context,helpRequest);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).rejectRequest , style: TextStyle(color: Colors.white),),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(10),

                    child: RaisedButton(

                      splashColor: Colors.white,
                      color: BasicColor.clr,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        DataBaseService().verify_help_request(helpRequest);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).approveRequest, style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(10),
              ),

            ],
          ),
        ),
      ),
    );
  });
}
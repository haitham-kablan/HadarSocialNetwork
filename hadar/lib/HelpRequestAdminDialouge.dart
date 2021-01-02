
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hadar/utils/HelpRequest.dart';
import 'package:marquee/marquee.dart';


import 'Design/basicTools.dart';


void HelpRequestAdminDialuge(context,HelpRequest helpRequest){

  showModalBottomSheet(context: context, builder: (BuildContext bc){
    return FractionallySizedBox(
      heightFactor: 1,
      child: Container(
        color: BasicColor.backgroundClr,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text('תיאור הבקשה' , style: TextStyle(
                      fontSize: 30,
                      color: BasicColor.clr,fontWeight: FontWeight.bold
                    ),),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 15 , left: 10),
                    child: Text(helpRequest.date.toString().substring(0,11) , style: TextStyle(fontSize: 15),),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 2,left: 10),
                    child: Text(helpRequest.date.toString().substring(11,19) , style: TextStyle(fontSize: 15),),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 2,right: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(helpRequest.sender_id ,style: TextStyle(fontSize: 18),textDirection: TextDirection.rtl, ),
                        Container(margin: EdgeInsets.only(right: 10),),
                        Text('מבקש העזרה:' ,
                          style: TextStyle(fontSize: 18 , color: BasicColor.clr ,),
                          textDirection: TextDirection.rtl,),


                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 2,right: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(helpRequest.category.description ,style: TextStyle(fontSize: 18),textDirection: TextDirection.rtl, ),
                        Container(margin: EdgeInsets.only(right: 10),),
                        Text('קטגוריה:' ,
                          style: TextStyle(fontSize: 18 , color: BasicColor.clr ,),
                          textDirection: TextDirection.rtl,),


                      ],
                    ),
                  ),

                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 2,right: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(margin: EdgeInsets.only(right: 10),),
                        Text('תיאור הבקשה:' ,
                          maxLines: 5,
                          style: TextStyle(fontSize: 18 , color: BasicColor.clr , ),
                          textDirection: TextDirection.rtl,),


                      ],
                    ),
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(helpRequest.description , textDirection: TextDirection.rtl,),
                    ),
                   )
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
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
                          onPressed: () {  },
                          child: Text('דחה בקשה' , style: TextStyle(color: Colors.white),),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(10),

                        child: RaisedButton(

                          splashColor: Colors.white,
                          color: BasicColor.clr,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          onPressed: () {  },
                          child: Text('אשר בקשה', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                  ),

                ],
              ),
          ),

    );
  });
}
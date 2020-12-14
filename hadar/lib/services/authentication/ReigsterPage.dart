import 'package:flutter/material.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:item_selector/item_selector.dart';

class ReigesterPage extends StatefulWidget {
  @override
  _ReigesterPageState createState() => _ReigesterPageState();
}

class _ReigesterPageState extends State<ReigesterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
//            Custom_Text_feild('שם מלא',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
//            Custom_Text_feild('תעודת זהות',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
//            Custom_Text_feild('מספר טלפון',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
//            Custom_Text_feild('אימיל',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
//            Custom_Text_feild('סיסמה',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
//            Custom_Text_feild('סיסמה עוד פעם',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            ItemSelectionController(
              child: ListView(
                children: List.generate(10, (int index) {
                  return ItemSelectionBuilder(
                    index: index,
                    builder: (BuildContext context, int index, bool selected) {
                      return Text('$index: $selected');
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}


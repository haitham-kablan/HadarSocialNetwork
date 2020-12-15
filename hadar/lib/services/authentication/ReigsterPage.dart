import 'package:flutter/material.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';
import 'package:item_selector/item_selector.dart';

class ReigesterPage extends StatefulWidget {
  @override
  _ReigesterPageState createState() => _ReigesterPageState();
}

class _ReigesterPageState extends State<ReigesterPage> {

  Map<String, Icon> tripTypes = user_types([Colors.black , Colors.black , Colors.black , Colors.black]);
  List<String> tripKeys ;
  String name;
  String id;
  String phone_number;
  String email;
  String pw;
  String second_pw;

  @override
  Widget build(BuildContext context) {

    List<String> tripKeys = tripTypes.keys.toList();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: [
            Custom_Text_feild('שם מלא',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Custom_Text_feild('תעודת זהות',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Custom_Text_feild('מספר טלפון',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Custom_Text_feild('אימיל',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Custom_Text_feild('סיסמה',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Custom_Text_feild('סיסמה עוד פעם',Icon(Icons.account_circle_rounded),Colors.purple,Colors.orange),
            Text(
              'נרשם בתור:',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.right,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                scrollDirection: Axis.vertical,
                primary: false,
                children: List.generate(tripTypes.length, (index) {
                  return FlatButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        tripTypes[tripKeys[index]],
                        Text(tripKeys[index]),
                      ],
                    ),
                    onPressed: ()  {
                      setState(() {
                        tripTypes = update_list(index);
                      });
                    },
                  );
                }),
              ),
            ),

            RaisedButton(
              onPressed: (){
                if (Navigator.canPop(context)) {
                  Navigator.pop(
                    context,
                  );
              }
             },
              child: Text('הרשמה'),
            ),
          ],
        ),

    );
  }

  Map<String, Icon> update_list(int index) {

    List<Color> new_clrs = [index == 0 ? Colors.blue : Colors.black ,
      index == 1 ? Colors.blue : Colors.black,
      index == 2 ? Colors.blue : Colors.black,
      index == 3 ? Colors.blue : Colors.black];
    return user_types(new_clrs);
  }

}


Map<String, Icon> user_types(List<Color> colors) => {

  "מנהל": Icon(Icons.admin_panel_settings_outlined, size: 30 ,color: colors[0]),
  "מבקש עזרה": Icon(Icons.directions_bus, size: 30,color: colors[1]),
  "עוזר": Icon(Icons.train, size: 30,color: colors[2] ),
  "צד שלישי": Icon(Icons.airplanemode_active, size: 30,color: colors[3] ),
};

bool Check_user(name, String id, String phone_number, String email, String pw, String second_pw){


}



import 'package:flutter/material.dart';


/*/
  user this if u want to get to another screen by clciking it
 */
class RounderWightedButtons extends StatelessWidget {
  final int first_weight;
  final int second_weight;
  final int third_weight;
  final String button_text;
  final Widget where_to_go;

  RounderWightedButtons(this.first_weight,this.second_weight,this.third_weight,this.button_text , this.where_to_go);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SizedBox(

          ),
          flex: third_weight,
        ),
        Expanded(
          flex: second_weight,
          child: RaisedButton(
            child: Text(button_text),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => where_to_go),
              );
            },
          ),
        ),
        Expanded(
          child: SizedBox(

          ),
          flex: third_weight,
        ),
      ],
    );
  }
}

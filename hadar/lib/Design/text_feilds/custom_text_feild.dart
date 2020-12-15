import 'package:flutter/material.dart';

class Custom_Text_feild extends StatefulWidget {
  Icon icon;
  String hint;
  Color border_color;
  Color on_tap_color;
  Custom_Text_feild(this.hint,this.icon,this.border_color,this.on_tap_color);
  @override
  _Custom_Text_feildState createState() => _Custom_Text_feildState(hint,icon,border_color,on_tap_color);
}

class _Custom_Text_feildState extends State<Custom_Text_feild> {

  Icon icon;
  String hint;
  Color border_color;
  Color on_tap_color;
  _Custom_Text_feildState(this.hint,this.icon,this.border_color,this.on_tap_color);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: TextField(
        textAlign:TextAlign.right,
        decoration: InputDecoration(
//          enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(30),
//            borderSide: BorderSide(color: border_color),
//          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: on_tap_color),
          ),
          suffixIcon: icon,
          hintText: hint,
        ),
      ),
    );
  }

}
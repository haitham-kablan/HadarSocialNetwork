import 'package:flutter/material.dart';

class DescriptionBox extends StatefulWidget {
  Icon icon;
  String hint;
  Color text_color;
  Color border_color;
  Color on_tap_color;
  var Validtor;
  var Controller;
  bool is_pw;
  var parent;

  DescriptionBox(this.hint, this.icon, this.border_color, this.on_tap_color,
      this.Validtor, this.Controller, this.is_pw, this.text_color,
      {this.parent});

  @override
  DescriptionBoxState createState() => DescriptionBoxState(hint, icon,
      border_color, on_tap_color, Validtor, Controller, is_pw, text_color);
}

class DescriptionBoxState extends State<DescriptionBox> {
  Icon icon;
  String hint;
  Color text_color;
  Color border_color;
  Color on_tap_color;
  bool is_pw;

  var Validtor;
  var Controller;

  DescriptionBoxState(
      this.hint,
      this.icon,
      this.border_color,
      this.on_tap_color,
      this.Validtor,
      this.Controller,
      this.is_pw,
      this.text_color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                style: TextStyle(
                  color:
                      text_color == Colors.grey ? Colors.black : text_color,
                ),
                autofocus: true,
                obscureText: is_pw,
                autocorrect: !is_pw,
                enableSuggestions: !is_pw,
                controller: Controller,
                validator: Validtor,
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: widget.hint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

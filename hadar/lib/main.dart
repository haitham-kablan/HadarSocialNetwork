import 'package:flutter/material.dart';
import 'package:hadar/home_page.dart';


void main() {
  runApp(MaterialApp(
    home: Log_In_Screen(),
  ));
}

class Log_In_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Hadar'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text("go next"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home_Page_Screen()),
            );
          },
        ),
      ),

    );
  }
}





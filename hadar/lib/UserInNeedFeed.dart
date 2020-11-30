
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class helpWindow extends StatelessWidget {
  static const String _title = 'helpWindow';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose a category'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColoredBox(child: (Text('Hey') ), color: (Colors.amberAccent),),
            RaisedButton(child: Text('groceries')),
            RaisedButton(child: Text('Babysitter')),
            RaisedButton(child: Text('Health issue')),
            RaisedButton(child: Text('Dentist')),
            RaisedButton(child: Text('Food')),
          ],
        ),
      ), backgroundColor: Colors.white70,
    );
  }
}

class UserInNeedFeed extends StatelessWidget {
  static const String _title = 'Feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('I need help'),
          onPressed: () =>
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => helpWindow()),
            )
          },
        ),
      ),
    );
  }
}

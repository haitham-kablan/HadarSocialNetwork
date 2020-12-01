import 'package:flutter/material.dart';

import './feed_page.dart';

class Home_Page_Screen extends StatelessWidget {
  static const String _title = 'Home Page';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}): super(key: key);


  //MyStatefulWidget.byWidget(this.runningWidget);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  //Widget runningWidget;
  final TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  /*static List<Widget> _widgetOptions = <Widget>[


  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(

         // child: _widgetOptions.elementAt(_selectedIndex),

        child: Container(
          margin: const EdgeInsets.all(10.0),
          //color: Colors.amber[600],
          //width: 48.0,
          //height: 48.0,
          child: Column(
            children: [
              Container(
                child: Text(
                  'Index 0: Home',
                  style: optionStyle,
                  //color: Colors.green
                )
              ),
              Container(
                child:Text(
                  'Index 1: Profile',
                  style: optionStyle,
                ),
                //color: Colors.amber,
              ),
            ],
          )
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
import 'package:flutter/material.dart';

import './feed_page.dart';

class Home_Page_Screen extends StatelessWidget {
  static const String _title = 'Home Page';
  Widget runningWidget;

  Home_Page_Screen(this.runningWidget);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(runningWidget),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.runningWidget}) : super(key: key);
  Widget runningWidget;


  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(runningWidget);
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  _MyStatefulWidgetState(this.runningWidget);

  Widget runningWidget;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Container(
              child: runningWidget,
              //color: Colors.green

    ),
    Container(
        child:Text(
              'Index 1: Profile',
              style: optionStyle,
          ),
        //color: Colors.amber,
    ),

  ];

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
          child: _widgetOptions.elementAt(_selectedIndex)
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
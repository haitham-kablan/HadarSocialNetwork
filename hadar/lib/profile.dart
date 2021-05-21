import 'dart:math';
import 'package:hadar/services/authentication/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/users/Admin.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/User.dart' as a;
import 'package:url_launcher/url_launcher.dart';
import 'Design/basicTools.dart';
import 'Design/mainDesign.dart';
import 'package:hadar/Design/text_feilds/custom_text_feild.dart';

import 'TechSupportForm.dart';

class Item {
  Item({
    this.name,
    this.builder,
    this.isExpanded = false,
  });

  String name;
  Widget builder;
  bool isExpanded;
}

class AboutMe extends StatelessWidget {
  a.User user;

  AboutMe(a.User currUser) {
    this.user = currUser;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.phoneNumber + '  :' + 'מספר טלפון',
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          user.email + '  :' + 'אימיל',
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class ManagePersonalInfo extends StatelessWidget {
  a.User user;
  final nameKey = GlobalKey<FormState>();
  final name_Controller = TextEditingController();

  ManagePersonalInfo(a.User currUser) {
    this.user = currUser;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Custom_Text_feild(
            'שנה סיסמא',
            Icon(Icons.account_circle_rounded, color: BasicColor.clr),
            BasicColor.clr,
            BasicColor.clr,
            name_Validator.Validate,
            name_Controller,
            false,
            BasicColor.clr,
          ),
          key: nameKey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class ContactUs extends StatelessWidget {
  a.User user;
  ProfilePage parent;

  ContactUs(a.User currUser, ProfilePage parent) {
    this.user = currUser;
    this.parent = parent;
  }

  _launchCaller() async {
    String number;
    number = '0526736167';
    var url = "tel:" + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          padding: EdgeInsets.only(right: 25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('למלא טופס'),
              Icon(Icons.wysiwyg_rounded),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TechSupportForm(parent)),
            );
          },
          textColor: Theme.of(context).primaryColor,
        ),
        FlatButton(
          padding: EdgeInsets.only(right: 25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('להתקשר'),
              Icon(Icons.phone),
            ],
          ),
          onPressed: () {
            _launchCaller();
          },
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}

class Other extends StatelessWidget {
  a.User user;

  Other(a.User currUser) {
    this.user = currUser;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          padding: EdgeInsets.only(right: 25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('הסר אותי מהמערכת'),
              Icon(Icons.person_remove),
            ],
          ),
          onPressed: () async {
            await DataBaseService().RemoveCurrentuserFromAuthentication();
            DataBaseService().RemoveUserfromdatabase(user);
            DataBaseService().Sign_out(context);
          },
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}

class SortByCat extends StatefulWidget {
  ProfilePage parent;
  a.User user;

  SortByCat(a.User currUser, ProfilePage parent) {
    this.user = currUser;
    this.parent = parent;
  }

  @override
  _SortByCatState createState() => _SortByCatState(user, parent);
}

class _SortByCatState extends State<SortByCat> {
  a.User user;
  ProfilePage parent;
  List<Item> _items;

  _SortByCatState(a.User currUser, ProfilePage parent) {
    this.user = currUser;
    this.parent = parent;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _items = _generateItems();
    });
  }

  List<Item> _generateItems() {
    List<Item> temp;
    temp = [
      Item(
        name: 'מידע עלי',
        builder: AboutMe(user),
      ),
      Item(
        name: 'נהל פרטים אישיים',
        builder: ManagePersonalInfo(user),
      ),
      Item(
        name: 'צור קשר',
        builder: ContactUs(user, parent),
      ),
      Item(
        name: 'אחר',
        builder: Other(user),
      ),
    ];
    return temp;
  }

  ExpansionPanelRadio _buildExpansionPanelRadio(Item item) {
    return ExpansionPanelRadio(
      value: item.name,
      backgroundColor: Colors.white,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          child: ListTile(
            title: Text(item.name),
            // subtitle: Text(item.name),
          ),
        );
      },
      body: item.builder,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      expandedHeaderPadding: EdgeInsets.all(10),
      dividerColor: BasicColor.backgroundClr,
      elevation: 4,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _items[index].isExpanded = !isExpanded;
        });
      },
      children: _items.map((item) => _buildExpansionPanelRadio(item)).toList(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  a.User user;
  a.User adminAccess;
  String privilege;

  ProfilePage(a.User currUser) {
    user = CurrentUser.curr_user;
    switch (user.privilege) {
      case Privilege.UserInNeed:
        privilege = 'User in need';
        break;
      case Privilege.Volunteer:
        privilege = 'Volunteer';
        break;
      case Privilege.Organization:
        privilege = 'Organization';
        break;
      case Privilege.Admin:
        privilege = 'Admin';
        adminAccess = user;
        user = currUser;
        break;
      default:
        privilege = 'default';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      home: Scaffold(
        bottomNavigationBar: BottomBar(),
        // bottomNavigationBar: checkBottomBar(),
        backgroundColor: BasicColor.backgroundClr,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: user.name),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      privilege,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black45,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SortByCat(user, this),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

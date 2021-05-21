import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/User.dart' as a;
import '../profile.dart';
import 'basicItemsForUserProfile.dart';

class MainInfo extends StatelessWidget {
  a.User user;
  String privilege;

  MainInfo(a.User user,String privilege) {
    this.user = user;
    this.privilege = privilege;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
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
        FlatButton(
          padding: EdgeInsets.only(right: 25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('התראות'),
              Icon(Icons.notifications),
            ],
          ),
          onPressed: () {
            //  TODO: turn notifications ON/OFF
          },
          textColor: Theme.of(context).primaryColor,
        ),
        FlatButton(
          padding: EdgeInsets.only(right: 25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('שנה מיקום קבוע'),
              Icon(Icons.location_on),
            ],
          ),
          onPressed: () {
            //  TODO: change location
          },
          textColor: Theme.of(context).primaryColor,
        ),
        FlatButton(
          padding: EdgeInsets.only(right: 25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('שנה סיסמא'),
              Icon(Icons.lock),
            ],
          ),
          onPressed: () {
            //  TODO: change password
          },
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
    // return Column(
    //   children: [

    // Form(
    //   child: Custom_Text_feild(
    //     'שנה סיסמא',
    //     Icon(Icons.account_circle_rounded, color: BasicColor.clr),
    //     BasicColor.clr,
    //     BasicColor.clr,
    //     name_Validator.Validate,
    //     name_Controller,
    //     false,
    //     BasicColor.clr,
    //   ),
    //   key: nameKey,
    // ),
    // SizedBox(
    //   height: 10,
    // ),
    //   ],
    // );
  }
}

class SignOut extends StatelessWidget {
  const SignOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'יציאה',
            style: TextStyle(
                fontSize: 17.0,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
            // fontWeight: FontWeight.w400),
          ),
          Icon(Icons.logout),
        ],
      ),
      onPressed: () {
        DataBaseService().Sign_out(context);
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}

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

class BasicLists {
  a.User user;
  ProfilePage parent;
  List<Item> listForUserView;
  List<Item> listForUserAdminView;
  BasicLists(a.User user,ProfilePage parent){
    this.user = user;
    this.parent = parent;
    listForUserView= [
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
        builder: OtherUserAccess(user),
      ),
    ];
    listForUserAdminView=[
      Item(
        name: 'מידע על המשתמש',
        builder: AboutMe(user),
      ),
      Item(
        name: 'אחר',
        builder: OtherAdminAccess(user),
      ),
    ];
  }
}

class SortByCatForAll extends StatefulWidget {
  ProfilePage parent;
  a.User user;
  List<Item> items;

  SortByCatForAll(a.User currUser, ProfilePage parent,List<Item> items) {
    this.user = currUser;
    this.parent = parent;
    this.items=items;
  }

  @override
  _SortByCatForAllState createState() => _SortByCatForAllState(user, parent,items);
}

class _SortByCatForAllState extends State<SortByCatForAll> {
  a.User user;
  ProfilePage parent;
  List<Item> _items;

  _SortByCatForAllState(a.User currUser, ProfilePage parent,List<Item> items) {
    this.user = currUser;
    this.parent = parent;
    this._items=items;
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
          ),
        );
      },
      body: item.builder,
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


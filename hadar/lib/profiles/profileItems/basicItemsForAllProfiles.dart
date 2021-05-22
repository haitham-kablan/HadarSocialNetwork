import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Privilege.dart';
import 'package:hadar/users/User.dart' as a;
import 'package:hadar/utils/HelpRequestType.dart';
import '../profile.dart';
import 'basicItemsForAdminProfile.dart';
import 'basicItemsForUserProfile.dart';

//when a user clicks on the category, he gets a description box,
// where he can describe his request
class DescriptonBox extends StatefulWidget {
  DescriptonBox({Key key, this.title}) : super(key: key);
  _DescriptonBox desBoxState = _DescriptonBox();
  final String title;

  void processText() {
    desBoxState.processText();
  }

  @override
  _DescriptonBox createState() => desBoxState;
}

class _DescriptonBox extends State<DescriptonBox> {
  String _inputtext = 'waiting..';
  TextEditingController inputtextField = TextEditingController();

  void processText() {
    setState(() {
      _inputtext = inputtextField.text;
      HelpRequestType helpRequestType= HelpRequestType(_inputtext);
      _inputtext=null;
      DataBaseService().addHelpRequestTypeDataBase(helpRequestType);
      Navigator.of(context).pop();
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 110,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(2.0),
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: inputtextField,
                      textAlign: TextAlign.right,
                      autofocus: true,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: widget.title,
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}

class MainInfo extends StatelessWidget {
  a.User user;
  String privilege;

  MainInfo(a.User user, String privilege) {
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
  ProfileButton buttonCreate;

  ManagePersonalInfo(a.User currUser) {
    this.user = currUser;
    buttonCreate=ProfileButton ();
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle style =buttonCreate.getStyle(context);
    return Column(
      children: [
        TextButton(
          child: buttonCreate.getChild('התראות', Icons.notifications_rounded),
          style: style,
          onPressed: () {
            //  TODO: turn notifications ON/OFF
          },
        ),
        TextButton(
          child: buttonCreate.getChild('שנה מיקום קבוע', Icons.location_on),
          style: style,
          onPressed: () {
            //  TODO: change location
          },
        ),
        TextButton(
          child: buttonCreate.getChild('שנה סיסמא', Icons.lock),
          style: style,
          onPressed: () {
            //  TODO: change password
          },
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
    return
      TextButton(
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
            ),
            Icon(Icons.logout),
          ],
        ),
        style: TextButton.styleFrom(
          primary: Theme
              .of(context)
              .primaryColor,
          padding: EdgeInsets.only(left: 10.0),
        ),
        onPressed: () {
          DataBaseService().Sign_out(context);
        },
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
  Widget parent;
  List<Item> listForUserView;
  List<Item> listForUserAdminView;
  List<Item> listForAdminView;

  BasicLists(a.User user, Widget parent) {
    this.user = user;
    this.parent = parent;
      listForAdminView = [
        Item(
          name: 'מידע עלי',
          builder: AboutMe(user),
        ),
        Item(
          name: 'נהל פרטים אישיים',
          builder: ManagePersonalInfo(user),
        ),
        Item(
          name: 'נהל את המערכת',
          builder: ManageTheSystem(),
        ),
        Item(
          name: 'אחר',
          builder: OtherUserAccess(user),
        ),
      ];
        listForUserView = [
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
        listForUserAdminView = [
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
  Widget parent;
  a.User user;
  List<Item> items;

  SortByCatForAll(a.User currUser, Widget parent, List<Item> items) {
    this.user = currUser;
    this.parent = parent;
    this.items = items;
  }

  @override
  _SortByCatForAllState createState() =>
      _SortByCatForAllState(user, parent, items);
}

class _SortByCatForAllState extends State<SortByCatForAll> {
  a.User user;
  Widget parent;
  List<Item> _items;

  _SortByCatForAllState(a.User currUser, Widget parent, List<Item> items) {
    this.user = currUser;
    this.parent = parent;
    this._items = items;
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

class ProfileButton{
  Widget getChild(String title,IconData icon){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(title),
        Icon(icon),
      ],
    );
  }
  ButtonStyle getStyle(BuildContext context){
    return TextButton.styleFrom(
    primary: Theme
        .of(context)
        .primaryColor,
    padding: EdgeInsets.only(right: 25.0),
    );
  }
}


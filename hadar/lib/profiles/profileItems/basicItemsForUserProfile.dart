import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/User.dart' as a;
import 'package:url_launcher/url_launcher.dart';
import '../../TechSupportForm.dart';
import '../profile.dart';

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

class OtherUserAccess extends StatelessWidget {
  a.User user;

  OtherUserAccess(a.User currUser) {
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

class OtherAdminAccess extends StatelessWidget {
  a.User user;

  OtherAdminAccess(a.User currUser) {
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
              const Text('הסר את המשתמש מהמערכת'),
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
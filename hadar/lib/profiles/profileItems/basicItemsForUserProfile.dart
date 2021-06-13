import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/User.dart' as a;
import 'package:url_launcher/url_launcher.dart';
import '../../TechSupportForm.dart';
import '../profile.dart';
import 'basicItemsForAllProfiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUs extends StatelessWidget {
  a.User user;
  Widget parent;
  ProfileButton buttonCreate;

  ContactUs(a.User currUser, Widget parent) {
    this.user = currUser;
    this.parent = parent;
    buttonCreate = ProfileButton();
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
    ButtonStyle style = buttonCreate.getStyle(context);
    return Column(
      children: [
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).fillApplication, Icons.wysiwyg_rounded),
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TechSupportForm(parent, context)),
            );
          },
        ),
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).call, Icons.phone),
          style: style,
          onPressed: () {
            _launchCaller();
          },
        ),
      ],
    );
  }
}

class OtherUserAccess extends StatelessWidget {
  a.User user;
  ProfileButton buttonCreate;

  OtherUserAccess(a.User currUser) {
    this.user = currUser;
    buttonCreate = ProfileButton();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).deleteMeFromSystem, Icons.person_remove),
          style: buttonCreate.getStyle(context),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => RemoveUser(user),
            );
          },
        ),
      ],
    );
  }
}

class OtherAdminAccess extends StatelessWidget {
  a.User user;
  ProfileButton buttonCreate;

  OtherAdminAccess(a.User currUser) {
    this.user = currUser;
    buttonCreate = ProfileButton();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          child: buttonCreate.getChild(
              AppLocalizations.of(context).deleteUserFromSystem, Icons.person_remove),
          style: buttonCreate.getStyle(context),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => RemoveUser(user),
            );
          },
        ),
      ],
    );
  }
}

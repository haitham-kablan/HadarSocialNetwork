import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';

import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/Organization.dart';
import 'package:hadar/users/Privilege.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';


class removeOrganization extends StatelessWidget {
  Organization org;

  removeOrganization(Organization org) {
    this.org = org;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      backgroundColor: BasicColor.backgroundClr,
      title: Center(
          child: Text(AppLocalizations.of(context).areYouSure)
      ),
      actions: <Widget>[
        Row(

          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme
                    .of(context)
                    .primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(AppLocalizations.of(context).cancel),
            ),
            Spacer(flex: 1,),
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme
                    .of(context)
                    .primaryColor,
              ),
              onPressed: (){
                DataBaseService().RemoveOrginazation(org.name);
                Navigator.pop(context, true);
              },
              child: Text(AppLocalizations.of(context).confirm),
            ),
          ],
        ),
      ],
    );
  }
}

class OrganizationsInfoList extends StatelessWidget {
  final BuildContext currContext;

  OrganizationsInfoList(this.currContext);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Organization>>.value(
      value: DataBaseService().getAllOrganizations(),
      child: _OrganizationFeed(currContext),
    );
  }
}

class _OrganizationFeed extends StatelessWidget {
  final BuildContext currContext;

  _OrganizationFeed(this.currContext);

  @override
  Widget build(BuildContext context) {
    final List<Organization> organizations =
    Provider.of<List<Organization>>(context);

    List<_OrganizationInfo> organizationsTiles = [];

    if (organizations != null) {
      organizationsTiles = organizations.map((Organization organization) {
        return _OrganizationInfo(organization, currContext);
      }).toList();
    }

    return Scaffold(
      body: ListView(
        semanticChildCount:
        (organizations == null) ? 0 : organizations.length,
        padding: const EdgeInsets.only(bottom: 70.0, left: 8, right: 8),
        children: organizationsTiles,
      ),
    );
  }
}

class _OrganizationInfo extends StatelessWidget {
  final Organization organization;
  final BuildContext currContext;

  _OrganizationInfo(this.organization, this.currContext);

  _launchCaller(String number) async {
    var url = "tel:" + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  Widget showDelete(Organization org,BuildContext context){
    if(CurrentUser.curr_user.privilege == Privilege.Admin) {
      return
        Column(
          children: [
            SizedBox( height: 10,),
            TextButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(AppLocalizations.of(currContext).delete),
                    Icon(Icons.delete),
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => removeOrganization(org),
                  );
                }
            ),
          ],
        );
    }
    else{
      return SizedBox();
    }
  }

  Widget _styledText(String text, {bool isRTL = false}){
    return Text(
        text,
        textDirection: isRTL ? TextDirection.rtl : null,
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.blueGrey,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w400),
      );
  }

  List<Widget> _adjustRowToLang(List<Widget> lst){
    String langCode = MainApp.of(currContext).getLangCode();
    return lst;
    // return (langCode == "he" || langCode == "ar") ? lst : lst.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    String langCode = MainApp.of(currContext).getLangCode();
    bool isRTL = (langCode == "he" || langCode == "ar");
    return ExpansionTile(
      title: Text(organization.name),

      children: [
        Table(
          //border: TableBorder.symmetric(),
          // columnWidths: const <int, TableColumnWidth>{
          //   0: IntrinsicColumnWidth(),
          //   1: FlexColumnWidth(),
          // },
          //defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          // textDirection: TextDirection.rtl,



          children: <TableRow>[
            TableRow(
              children: [
                _styledText(AppLocalizations.of(currContext).telNumberTwoDots),
                Row(
                  mainAxisAlignment: isRTL ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    _styledText(organization.phoneNumber + ' '),
                    GestureDetector(
                      onTap: () {
                        _launchCaller(organization.phoneNumber);
                      },
                      child: Icon(
                        Icons.call,
                        size: 20.0,
                        color: BasicColor.clr,
                      ),
                    ),
                  ],
                ),
              ],

            ),

            TableRow(
              children: [
                _styledText(AppLocalizations.of(currContext).emailTwoDots),
                _styledText(organization.email, isRTL: true),
              ],
            ),
            TableRow(
              children: [
                _styledText(AppLocalizations.of(currContext).locationTwoDots),
                _styledText(organization.location, isRTL: true),
              ],
            ),
            TableRow(
              children: [
                _styledText(AppLocalizations.of(currContext).services),
                Container(
                  alignment: Alignment.topRight,

                  child: Column(
                    crossAxisAlignment: isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: organization.services.map(
                            (service) => _styledText(service.description)
                    ).toList(),
                  ),
                ),
              ],
            ),

          ],
        ),
        showDelete(organization,context),
      ],
    );
  }
}

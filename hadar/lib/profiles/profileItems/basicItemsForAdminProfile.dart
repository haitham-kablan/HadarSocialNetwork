import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/adminFeatures/adminAddOrganization.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import '../../adminFeatures/adminAddHelpRequest.dart' as a;
import '../../adminFeatures/adminManageOrganizations.dart';
import '../../userInquiryView.dart';
import 'basicItemsForAllProfiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageTheSystem extends StatelessWidget {
  ProfileButton buttonCreate;
  DescriptonBox desBox;

  Widget addCategory(BuildContext context) {
    return new AlertDialog( backgroundColor: BasicColor.backgroundClr,
      title: Center(child: Text(AppLocalizations.of(context).addCategory)),
      content:desBox,
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            desBox.processText();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(AppLocalizations.of(context).approve),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonCreate=ProfileButton();
    ButtonStyle style =buttonCreate.getStyle(context);
    return Column(
      children: [
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).addCategory, Icons.add_box_outlined),
          style: style,
          onPressed: () {
            desBox = DescriptonBox();
            showDialog(
              context: context,
              builder: (BuildContext context) => addCategory(context),
            );
          },
        ),
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).addRequest, Icons.post_add),
          style: style,
          onPressed: () async {
            List<HelpRequestType> types =
            await DataBaseService().helpRequestTypesAsList();
            types.add(HelpRequestType('אחר..'));
            //we must add אחר so it always appears on the last of the list
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => a.AdminRequestWindow(types, context)),
            );
          },
        ),
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).addOrginaization, Icons.add_business_outlined),
          style: style,
          onPressed: () async {
            List<HelpRequestType> types =
            await DataBaseService().helpRequestTypesAsList();
            types.add(HelpRequestType('אחר'));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>AddOrganizationWindow(types)),
            );
          },
        ),
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).showAllOrginaization, Icons.business_outlined),
          style: style,
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>ManageOrganizations()),
          );
          },
        ),
        TextButton(
          child: buttonCreate.getChild(AppLocalizations.of(context).usersInquiries, Icons.warning_rounded),
          style: style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => userInquiryView()),
            );
          },
        ),
      ],
    );
  }
}

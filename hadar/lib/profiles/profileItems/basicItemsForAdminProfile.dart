import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
<<<<<<< Updated upstream
=======
import 'package:hadar/adminFeatures/adminAddOrganization.dart';
import 'package:hadar/adminFeatures/adminManageOrganizations.dart';
>>>>>>> Stashed changes
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import '../../adminAddHelpRequest.dart' as a;
import '../../userInquiryView.dart';
import 'basicItemsForAllProfiles.dart';


class ManageTheSystem extends StatelessWidget {
  ProfileButton buttonCreate;
  DescriptonBox desBox;

  Widget addCategory(BuildContext context) {
    return new AlertDialog( backgroundColor: BasicColor.backgroundClr,
      title: Center(child: const Text('הוספת קטיגוריה')),
      content:desBox,
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            desBox.processText();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('אישור'),
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
          child: buttonCreate.getChild('הוספת קטיגוריה', Icons.add_box_outlined),
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
          child: buttonCreate.getChild('הוספת בקשה', Icons.post_add),
          style: style,
          onPressed: () async {
            List<HelpRequestType> types =
            await DataBaseService().helpRequestTypesAsList();
            types.add(HelpRequestType('אחר..'));
            //we must add אחר so it always appears on the last of the list
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => a.AdminRequestWindow( types)),
            );
          },
        ),
        TextButton(
          child: buttonCreate.getChild('הוספת עמותה',Icons.add_business_outlined),
          style: style,
          onPressed: () {
            //  TODO: add an organization
          },
        ),
        TextButton(
          child: buttonCreate.getChild('הצג כל העמותות',Icons.business_outlined),
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
          child: buttonCreate.getChild('פניות ממשתמשים',Icons.warning_rounded),
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

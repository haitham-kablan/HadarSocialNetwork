import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'basicItemsForAllProfiles.dart';


class ManageTheSystem extends StatelessWidget {
  ProfileButton buttonCreate;
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
            //  TODO: add category
          },
        ),
        TextButton(
          child: buttonCreate.getChild('הוספת בקשה', Icons.post_add),
          style: style,
          onPressed: () {
            //  TODO: add a request
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
            //  TODO: go to the organizations page
          },
        ),
        TextButton(
          child: buttonCreate.getChild('פניות ממשתמשים',Icons.warning_rounded),
          style: style,
          onPressed: () {
            //  TODO: view all inquiries
          },
        ),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/descriptionBox.dart';
import 'package:hadar/Design/errorShowBottomSheet.dart';
import 'package:hadar/profiles/profileItems/validators.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/CurrentUser.dart';
import 'package:hadar/users/User.dart' as a;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget changePasswordDialogue(BuildContext context) {
  a.User user = CurrentUser.curr_user;
  final currentPassword = GlobalKey<FormState>();
  final newPasswordfirst = GlobalKey<FormState>();
  final newPasswordsec = GlobalKey<FormState>();
  final currentPass_controller = TextEditingController();
  final firstPass_Controller = TextEditingController();
  final sectPass_Controller = TextEditingController();

  return SingleChildScrollView(
    child: new AlertDialog(
      backgroundColor: BasicColor.backgroundClr,
      title: Center(child: Text(AppLocalizations.of(context).changePassword)),
      content: Column(
        children: [
          Container(
            height: 90,
            child: Form(
              child: DescriptionBox(
                  AppLocalizations.of(context).current,
                  Icon(Icons.lock, color: Colors.white),
                  Colors.white,
                  Colors.white,
                  Validators.password_Validator,
                  currentPass_controller,
                  true,
                  Colors.black),
              key: currentPassword,
            ),
          ),
          Container(
            height: 90,
            child: Form(
              child: DescriptionBox(
                  AppLocalizations.of(context).newPass,
                  Icon(Icons.lock, color: Colors.white),
                  Colors.white,
                  Colors.white,
                  Validators.password_Validator,
                  firstPass_Controller,
                  true,
                  Colors.black),
              key: newPasswordfirst,
            ),
          ),
          Container(
            height: 90,
            child: Form(
              child: DescriptionBox(
                  AppLocalizations.of(context).reTypeNew,
                  Icon(Icons.lock, color: Colors.white),
                  Colors.white,
                  Colors.white,
                  Validators.password_Validator,
                  sectPass_Controller,
                  true,
                  Colors.black),
              key: newPasswordsec,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(AppLocalizations.of(context).cancel),
            ),
            Spacer(
              flex: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () async{

                if (currentPass_controller.text.isEmpty){
                  showError(context, AppLocalizations.of(context).passworIsnotValid,
                      Icons.warning_amber_rounded);
                  return;
                }

                bool match = await DataBaseService().checkIfPasswordIsMatch(user.email, currentPass_controller.text);

                if (!match){
                  showError(context, AppLocalizations.of(context).passworIsnotValid,
                      Icons.warning_amber_rounded);
                  return;
                }

                if (firstPass_Controller.text.isEmpty || sectPass_Controller.text.isEmpty ) {
                  showError(context, AppLocalizations.of(context).cantEmptyPassword,
                      Icons.warning_amber_rounded);
                  return;
                }

                if (firstPass_Controller.text != sectPass_Controller.text ) {
                    showError(context, AppLocalizations.of(context).passDontMatch,
                        Icons.warning_amber_rounded);
                    return;
                }

                  Navigator.pop(context, true);
                //  TODO: when done call changePassword
                DataBaseService.changePassword(firstPass_Controller.text);

              },
              child: Text(AppLocalizations.of(context).confirm),
            ),
          ],
        ),
      ],
    ),
  );
}

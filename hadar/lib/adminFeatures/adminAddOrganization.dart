import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/descriptionBox.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/Organization.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../Design/mainDesign.dart';
import '../profiles/adminProfile.dart';
import '../profiles/profileItems/validators.dart';
import '../users/Privilege.dart';

class checkBoxForCategories extends StatefulWidget {
  List<HelpRequestType> types;
  _checkBoxForCategoriesState state;

  checkBoxForCategories(List<HelpRequestType> types) {
    this.types = types;
  }

  @override
  _checkBoxForCategoriesState createState() =>
      state =_checkBoxForCategoriesState(types);

  List<HelpRequestType> getSelectedItems() {
    return state.getSelectedItems();
  }

}

class _checkBoxForCategoriesState extends State<checkBoxForCategories> {
  List<HelpRequestType> types;
  List selected_items = [];
  final formKey = new GlobalKey<FormState>();

  _checkBoxForCategoriesState(List<HelpRequestType> types) {
    this.types = types;
  }

  List<HelpRequestType> getSelectedItems() {
    return selected_items;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child:
            Directionality(
              textDirection: TextDirection.rtl,
              child: MultiSelectDialogField(
                cancelText: Text('בטל'),
                confirmText: Text('אישור'),
                searchHint: 'חיפוש',
                title: Text('בחר אחד או יותר'),
                buttonText: Text(
                  'בחר אחד או יותר', textDirection: TextDirection.rtl,),
                searchable: true,
                items: types.map((e) => MultiSelectItem(e, e.description))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  selected_items = values;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddOrganizationWindow extends StatefulWidget {
  List<HelpRequestType> types;

  AddOrganizationWindow(List<HelpRequestType> types) {
    this.types = types;
  }

  @override
  _AddOrganizationWindowState createState() =>
      _AddOrganizationWindowState(types);
}

class _AddOrganizationWindowState extends State<AddOrganizationWindow> {
  List<HelpRequestType> types;
  final orgNameKey = GlobalKey<FormState>();
  final orgPhoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final locationKey = GlobalKey<FormState>();

  String _error_msg = '';
  bool alert = false;
  bool clicked = false;
  Privilege clicked_priv = null;
  final name_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final location_Controller = TextEditingController();
  checkBoxForCategories categories;

  _AddOrganizationWindowState(List<HelpRequestType> types) {
    this.types = types;
    this.categories=checkBoxForCategories(types);
  }

  Widget getRelContainer(Form form) {
    return Container(
      height: 115,
      child: form,
    );
  }

  Widget showAlert_as_col() {
    if (alert) {
      return Container(
        color: BasicColor.clr,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(65, 8, 65, 8),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    alert = false;
                  });
                },
              ),
            ),
            Expanded(
              child: Text(
                _error_msg,
                maxLines: 3,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.error_outline, color: Colors.white),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: AdminBottomBar(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
              MySliverAppBar(expandedHeight: 150, title: 'הוספת עמותה'),
              pinned: true,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Container(child: showAlert_as_col()),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'שם עמותה',
                            Icon(Icons.account_circle_rounded,
                                color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidateName,
                            name_Controller,
                            false,
                            Colors.black),
                        key: orgNameKey,
                      ),
                    ),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'מספר טלפון',
                            Icon(Icons.phone, color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidatePhone,
                            phone_Controller,
                            false,
                            Colors.black),
                        key: orgPhoneKey,
                      ),
                    ),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'כתובת אלקטרונית',
                            Icon(Icons.email, color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidateEmail,
                            email_Controller,
                            false,
                            Colors.black),
                        key: emailKey,
                      ),
                    ),
                    getRelContainer(
                      Form(
                        child: DescriptionBox(
                            'כתובת',
                            Icon(Icons.location_on, color: Colors.white),
                            Colors.white,
                            Colors.white,
                            Validators.ValidateLocation,
                            location_Controller,
                            false,
                            Colors.black),
                        key: locationKey,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, right: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'שירותי העמותה:',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: BasicColor.clr,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(child: categories),
                    RaisedButton(
                      onPressed: () {
                        if (!orgNameKey.currentState.validate() ||
                            !orgPhoneKey.currentState.validate() ||
                            !emailKey.currentState.validate() ||
                            !locationKey.currentState.validate()) {
                          return;
                        }
                        Organization org = new Organization(
                            name_Controller.text, phone_Controller.text, email_Controller.text,
                            location_Controller.text, categories.getSelectedItems());
                        DataBaseService().addOrganizationToDataBase(org);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminProfile()),
                        );
                      },
                      child: Text('אישור'),
                    ),
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

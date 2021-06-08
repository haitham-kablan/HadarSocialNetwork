import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/Design/descriptionBox.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../Design/mainDesign.dart';
import '../profiles/adminProfile.dart';
import '../profiles/profileItems/validators.dart';
import '../users/Privilege.dart';

class checkBoxForCategories extends StatefulWidget {
  List<HelpRequestType> types;
  checkBoxForCategories(List<HelpRequestType> types){
    this.types=types;
  }

  @override
  _checkBoxForCategoriesState createState() => _checkBoxForCategoriesState(types);
}

class _checkBoxForCategoriesState extends State<checkBoxForCategories> {
  List<HelpRequestType> types;
  List<String> types_string;
  List _myActivities;
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();

  _checkBoxForCategoriesState(List<HelpRequestType> types){
    this.types=types;
    types_string= List<String>();
    for (HelpRequestType type in types){
      types_string.add(type.description);
    }

  }
  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myActivitiesResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
    }
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
            child: MultiSelectFormField(
              autovalidate: false,
              // title: 'My workouts',
              // validator: (value) {
              //   if (value == null || value.length == 0) {
              //     return 'Please select one or more options';
              //   }
              // },
              dataSource: types_string,
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              required: true,
              // hintText: 'Please choose one or more',
              // value: _myActivities,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _myActivities = value;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              child: Text('Save'),
              onPressed: _saveForm,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(_myActivitiesResult),
          )
        ],
      ),
    );
  }
}

class AddOrganizationWindow extends StatefulWidget {
  List<HelpRequestType> types;
  AddOrganizationWindow(List<HelpRequestType> types){
    this.types=types;
  }
  @override
  _AddOrganizationWindowState createState() => _AddOrganizationWindowState(types);
}

class _AddOrganizationWindowState extends State<AddOrganizationWindow> {
  List<HelpRequestType> types;
  final orgNameKey = GlobalKey<FormState>();
  final orgPhoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final locationKey = GlobalKey<FormState>();

  // List<HelpRequestType> types;
  String _error_msg = '';
  bool alert = false;
  bool clicked = false;
  Privilege clicked_priv = null;
  final name_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final email_Controller = TextEditingController();
  final location_Controller = TextEditingController();

  _AddOrganizationWindowState(List<HelpRequestType> types){
    this.types=types;
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
                    Container(height: 300, child: checkBoxForCategories(types)),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (!orgNameKey.currentState.validate() ||
                            !orgPhoneKey.currentState.validate() ||
                            !emailKey.currentState.validate() ||
                            !locationKey.currentState.validate()) {
                          return;
                        }
                        //TODO:add services
                        //TODO:add to the database
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

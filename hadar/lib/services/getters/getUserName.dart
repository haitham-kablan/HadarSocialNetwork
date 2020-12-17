import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/users/User.dart';


/*
  documentId - is the id of the wanted user
  collectionReference - is the collection the user in
 */
class GetUserName extends StatelessWidget {
  final String documentId;
  final CollectionReference collectionReference;

  String _name = 'loading';

  GetUserName(this.documentId , this.collectionReference);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = collectionReference;

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          if(data == null){
            return Text('no data');
          }
          return Text("${data['name']}"
                    , style: TextStyle(
              color: BasicColor.userInNeedClr,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
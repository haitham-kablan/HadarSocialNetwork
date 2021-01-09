import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/provider/google_sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:hadar/users/User.dart' as hadar;
import 'LogInPage.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(4),
    child: OutlineButton.icon(
      label: Text(
        'Sign In With Google',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      highlightedBorderColor: Colors.black,
      borderSide: BorderSide(color: Colors.black),
      textColor: Colors.black,
      icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
      onPressed: () {
        final provider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.login();
      },
    ),
  );
}

class LoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)  {
          final provider = Provider.of<GoogleSignInProvider>(context);
          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {
            auth.User user = auth.FirebaseAuth.instance.currentUser;
            getRightWidgetForUser(user);
            return null;
          } else {
            return LogInPage();
          }
        },
      ),
    ),
  );

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      //CustomPaint(painter: BackgroundPainter()),
      Center(child: SpinKitCircle(color: BasicColor.clr,)),
    ],
  );
  
  Future<Widget> getRightWidgetForUser(auth.User user) async{
      
    hadar.User curr_user = await DataBaseService().getCurrentUser();
    if (curr_user != null){
      //TODO : GO TO RELVENAT PAGE
    }else{
      //2 options
      //isnot verfivied
      //MIGHT BE PROBLEM HERE , IF THIS IS HIS FIRST TIME HE WILL BE VERFIED SO FIRST CHECK
      if (await DataBaseService().checkIfVerfied(curr_user.email)){
        //add to to verfication request
        //take his pratem
      }else{
        // show alert the user unverifed yet
      }
      //firdst log in
    }
  }
}
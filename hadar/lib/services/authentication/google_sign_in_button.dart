import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/services/authentication/get_google_user_info.dart';
import 'package:hadar/services/authentication/provider/google_sign_in_provider.dart';
import 'package:hadar/users/CurrentUser.dart';
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

class NewLoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)   {
          final provider = Provider.of<GoogleSignInProvider>(context);
          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {
            auth.User user = auth.FirebaseAuth.instance.currentUser;
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Text(user.email),
                    RaisedButton(
                      child: Text('sign out'),
                      onPressed: (){
                        provider.logout(false);
                      },
                    ),
                  ],
                ),
              ),
            );
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

  Future<Widget> go_to_home_page(auth.User user) async {
    return await getRightWidgetForUser(user);
  }
  Future<Widget> getRightWidgetForUser(auth.User user) async{
      
    hadar.User curr_user = await DataBaseService().getCurrentUser();
    if (curr_user != null){
      return await CurrentUser.init_user();
    }else{
      //first time log in from google
      if (await DataBaseService().checkIfVerfied(curr_user.email)){
        return GoogleReigesterPage(user.email);
      }else{
        // show alert the user unverifed yet
        return Scaffold();
      }

    }
  }
}
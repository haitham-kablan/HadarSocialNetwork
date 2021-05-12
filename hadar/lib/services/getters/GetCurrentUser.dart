
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/authentication/LogInPage.dart';
import 'package:hadar/users/CurrentUser.dart';

class GetCurrentUser extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<Widget>(
      future: CurrentUser.init_user(),
      builder:
          (BuildContext context, AsyncSnapshot<Widget> snapshot) {

        if (snapshot.hasError) {
          return  LogInPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data == null ? LogInPage() : snapshot.data;
        }

        return Column(
          children: [
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset('assets/images/undraw_speed_test_wxl0.png'),
            ),
            SpinKitCircle(color: BasicColor.clr,),
            Expanded(child: SizedBox()),
          ],
        );
      },
    );
  }
}

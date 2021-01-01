
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart' as HRTile;

import 'file:///D:/Hussein/Technion/234311%20-%20yearly%20project/Yearly_project/hadar/lib/feeds/user_inneed_feed.dart' as UIF;
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'package:intl/intl.dart' as Intl;

// see https://flutter.dev/docs/cookbook/testing/widget/tap-drag for more..
Future<void> main() async {
  //'User_Inneed_Feed: ListView Tests'

  testWidgets('Modal BottomSheet content test', (WidgetTester tester) async {
    //Build our app and trigger a frame.
    //UserInNeed userInNeed = UserInNeed("הייתם קבלאן", "1234567890", "haitham@gmail.com", true, "123456786");

    HelpRequest helpRequest1 = HelpRequest(HelpRequestType('food'), 'I need some bread please', DateTime.now(), '123456786','');

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: UIF.HelpRequestStatusWidget(helpRequest1, null))
      )
    );

    expect(find.byType(RaisedButton), findsOneWidget);
    expect(find.text(helpRequest1.category.description + ":"), findsOneWidget);
    expect(find.text(helpRequest1.description), findsOneWidget);
    expect(find.text(helpRequest1.date.toString().substring(0, 16)), findsOneWidget);

  });

  testWidgets('user_inneed_feed: listview tile content test', (WidgetTester tester) async{

    //Build our app and trigger a frame.


    HelpRequest helpRequest1 = HelpRequest(HelpRequestType('food'), 'I need some bread please', DateTime.now(), '123456786','');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [HRTile.FeedTile(helpRequestWidget: UIF.HelpRequestItem(
              helpRequest: helpRequest1, parent: null,
            ),)],
          ),
        ),
      )
    );
    final Intl.DateFormat dateFormat = Intl.DateFormat.yMd().add_Hm();

    expect(find.text(dateFormat.format(helpRequest1.date)), findsOneWidget);
    expect(find.text(helpRequest1.category.description), findsOneWidget);
    expect(find.text(helpRequest1.description), findsOneWidget);

  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart' as HRTile;

import 'file:///D:/Hussein/Technion/234311%20-%20yearly%20project/Yearly_project/hadar/lib/feeds/user_inneed_feed.dart' as UIF;
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';

import 'package:intl/intl.dart' as Intl;

// see https://flutter.dev/docs/cookbook/testing/widget/tap-drag for more..
Future<void> main() async {
  testWidgets('volunteer_feed: listview tile content test', (WidgetTester tester) async{

    //Build our app and trigger a frame.


    HelpRequest helpRequest1 = HelpRequest(HelpRequestType('food'), 'I need some bread please', DateTime.now(), '123456786','');

    await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [HRTile.FeedTile(helpRequestWidget: HRTile.VolunteerFeedTile(helpRequest1),)],
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


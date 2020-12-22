
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hadar/feeds/feed_items/help_request_tile.dart';
import 'package:hadar/main_pages/UserInNeedPage.dart';
import 'package:hadar/services/DataBaseServices.dart';

import 'package:hadar/user_inneed_feed.dart';
import 'package:hadar/users/UserInNeed.dart';
import 'package:hadar/utils/HelpRequest.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:provider/provider.dart';

import '../dataBaseTest/DataBaseServiceMock.dart';


// see https://flutter.dev/docs/cookbook/testing/widget/tap-drag for more..
Future<void> main() async {
  testWidgets('user_inneed_feed: listview items matching test', (WidgetTester tester) async {
    //Build our app and trigger a frame.

    final firestore = MockFirestoreInstance();
    await firestore.clearPersistence();
    final DataBaseServiceMock dataBaseServiceMock = DataBaseServiceMock(firestore);

    UserInNeed userInNeed = UserInNeed("הייתם קבלאן", "1234567890", "haitham@gmail.com", true, "123456786");

    HelpRequest helpRequest1 = HelpRequest(HelpRequestType('food'), 'I need some bread please', DateTime.now(), '123456786','');
    HelpRequest helpRequest2 = HelpRequest(HelpRequestType('dentist'), 'My teeth hurt, please help', DateTime.now(), '123456786','');
    HelpRequest helpRequest3 = HelpRequest(HelpRequestType('other'), 'please help me transfer my things', DateTime.now(), '123456786','');
    HelpRequest helpRequest4 = HelpRequest(HelpRequestType('other'), 'please buy me a bottle of milk', DateTime.now(), '123456786','');

    await dataBaseServiceMock.addUserInNeedToDataBase(userInNeed);
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest1);
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest2);
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest3);
    await dataBaseServiceMock.addHelpRequestToDataBaseForUserInNeed(helpRequest4);

    //var helpRequestsList = dataBaseServiceMock.getUserHelpRequests(userInNeed);

    await tester.pumpWidget(StreamProvider<List<HelpRequest>>.value(
      value: dataBaseServiceMock.getUserHelpRequests(userInNeed),
      child: UserInNeedHelpRequestsFeed(),
    ));

    expect(find.byType(HelpRequestTile), findsNWidgets(4));
    expect(find.widgetWithText(Text, "dentist"), findsOneWidget);
    expect(find.widgetWithText(Text, "other"), findsNWidgets(2));

    /*expect(
        find.byWidget(
            HelpRequestTile(helpRequestWidget: HelpRequestItem(
              helpRequest: helpRequest1, parent: y,
            ),
            )
        ),
        findsOneWidget
    );
    expect(
        find.byWidget(
            HelpRequestTile(helpRequestWidget: HelpRequestItem(
              helpRequest: helpRequest2, parent: y,
            ),
            )
        ),
        findsOneWidget
    );
    expect(
        find.byWidget(
            HelpRequestTile(helpRequestWidget: HelpRequestItem(
              helpRequest: helpRequest3, parent: y,
            ),
            )
        ),
        findsOneWidget
    );*/
    /*print("maaaaaaaaaaaaa3");
    var count = 0;
    var count2 = 0;
    helpRequestsList.forEach((element) {
      element.forEach((element2) {
        count++;
      });
      count2++;
      /*print(element.description);
      expect(
          find.byWidget(
              HelpRequestTile(helpRequestWidget: HelpRequestItem(
                  helpRequest: element, parent: null,
                ),
              )
          ),
          findsOneWidget);
*/
    });
    print(count.toString());
    print(count2.toString());*/
  });
}


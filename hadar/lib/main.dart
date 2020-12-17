import 'package:flutter/material.dart';
import 'package:hadar/Design/basicTools.dart';

import 'Design/mainDesign.dart';


void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 150, title: 'USER'),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => ListTile(
                  title: Text("Index: $index"),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomBar(),
      ),
    ),
  );
}

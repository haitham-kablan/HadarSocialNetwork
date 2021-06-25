import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hadar/Design/basicTools.dart';
import 'package:hadar/services/DataBaseServices.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import '../Design/mainDesign.dart';
import '../feeds/feed_items/help_request_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesView extends StatelessWidget {
  List<HelpRequestType> categories;

  CategoriesView(this.categories);

  @override
  Widget build(BuildContext context) {
    List<FeedTile> feedTiles = [];

    if (categories != null) {
      feedTiles = categories.map((HelpRequestType category) {
        return FeedTile(
          tileWidget: CategoryItem(
            category: category,
            parent: this,
          ),
        );
      }).toList();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        semanticChildCount: (categories == null) ? 0 : categories.length,
        padding: const EdgeInsets.only(bottom: 70.0, top: 70),
        children: feedTiles,
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({this.category, this.parent}) : super(key: ObjectKey(category));

  final HelpRequestType category;
  final CategoriesView parent;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.category_rounded,
                  color: Colors.black54,
                ),
                Text(
                  "  " + category.description,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Row(
              children: [
                PopupMenuButton(
                  onSelected:(value) {
                    if(value == 1){
                      DataBaseService().RemoveCategory(category);
                    }
                  },
                  child: Center(child:Icon(Icons.more_vert, color: Colors.black54),),
                  itemBuilder: (context) {
                    List<PopupMenuEntry<dynamic>> list= [];
                    list.add(
                      PopupMenuItem(
                        child:Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.black54,
                            ),
                            Text(AppLocalizations.of(context).delete,),
                          ],
                        ),
                        value: 1,
                      ),
                    );
                    return list;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesViewPage extends StatelessWidget {
  List<HelpRequestType> types;

  CategoriesViewPage(this.types);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColor.backgroundClr,
      bottomNavigationBar: AdminBottomBar(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: MySliverAppBar(
                expandedHeight: 150,
                title: AppLocalizations.of(context).showAllCategories),
            pinned: true,
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                Expanded(child: CategoriesView(types)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

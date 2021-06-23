import 'package:flutter/cupertino.dart';
import 'package:hadar/utils/HelpRequestType.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class checkBoxForCategories extends StatefulWidget {
  List<HelpRequestType> types;
  _checkBoxForCategoriesState state;
  BuildContext currContext;

  checkBoxForCategories(List<HelpRequestType> types,BuildContext currContext) {
    this.currContext = currContext;
    this.types = types;
  }

  @override
  _checkBoxForCategoriesState createState() =>
      state =_checkBoxForCategoriesState(types);

  List<HelpRequestType> getSelectedItems() {
    return state.getSelectedItems();
  }

}

class _checkBoxForCategoriesState extends State<checkBoxForCategories> {
  List<HelpRequestType> types;
  List selected_items = [];
  final formKey = new GlobalKey<FormState>();

  _checkBoxForCategoriesState(List<HelpRequestType> types) {
    this.types = types;
  }

  List<HelpRequestType> getSelectedItems() {
    return selected_items;
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
            child:
            Directionality(
              textDirection: TextDirection.rtl,
              child: MultiSelectDialogField(
                cancelText: Text(AppLocalizations.of(widget.currContext).cancel),
                confirmText: Text(AppLocalizations.of(widget.currContext).approve),
                searchHint: AppLocalizations.of(widget.currContext).search,
                title: Text(AppLocalizations.of(widget.currContext).categories),
                buttonText: Text(
                    AppLocalizations.of(widget.currContext).categories),
                searchable: true,
                items: types.map((e) => MultiSelectItem(e, e.description))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  selected_items = values;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

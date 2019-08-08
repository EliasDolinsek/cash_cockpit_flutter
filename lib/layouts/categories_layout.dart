import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/category_item.dart';

import '../core/category.dart';

class CategoriesLayout extends StatelessWidget {
  final bool editMode;
  final Function onCategorySelected;
  final DataProvider dataProvider;

  const CategoriesLayout(
      {this.editMode = false,
      this.onCategorySelected(Category category),
      this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final category = dataProvider.categories.elementAt(index);
          return CategoryItem(
            category,
            key: Key(category.id),
            editMode: editMode,
            onCategorySelected: onCategorySelected,
          );
        },
        separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 4.0),
            ),
        itemCount: dataProvider.categories.length);
  }
}

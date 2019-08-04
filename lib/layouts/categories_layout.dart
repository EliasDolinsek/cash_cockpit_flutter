import 'package:flutter/material.dart';

import '../widgets/category_item.dart';

import '../core/category.dart';

import '../data/data_provider.dart';

class CategoriesLayout extends StatefulWidget {

  final bool editMode;
  final Function onCategorySelected;

  const CategoriesLayout({this.editMode = false, this.onCategorySelected(Category category)});

  @override
  _CategoriesLayoutState createState() => _CategoriesLayoutState();
}

class _CategoriesLayoutState extends State<CategoriesLayout> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataProvider.of(context).categories,
      builder: (context, snapshot){
        if(snapshot.hasData){
          final categories = snapshot.data;
          return ListView.separated(
              itemBuilder: (context, index) {
                final category = categories.elementAt(index);
                return CategoryItem(
                  category,
                  key: Key(category.id),
                  editMode: widget.editMode,
                  onCategorySelected: widget.onCategorySelected,
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 4.0),
              ),
              itemCount: categories.length);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

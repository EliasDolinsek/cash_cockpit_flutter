import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/category_item.dart';

import '../core/category.dart';

import '../data/data_provider.dart';
import '../data/data_manager.dart' as dataManager;

class CategoriesLayout extends StatefulWidget {

  final bool editMode;
  final Function onCategorySelected;

  const CategoriesLayout({this.editMode = false, this.onCategorySelected(Category category)});

  @override
  _CategoriesLayoutState createState() => _CategoriesLayoutState();
}

class _CategoriesLayoutState extends State<CategoriesLayout> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      DataProvider.of(context).categoriesProvider.onChanged = () => setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = DataProvider.of(context).categoriesProvider.categoeries;
    return ListView.separated(
        itemBuilder: (context, index) {
          return CategoryItem(
            categories.elementAt(index),
            editMode: widget.editMode,
            onCategorySelected: widget.onCategorySelected,
          );
        },
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 4.0),
        ),
        itemCount: categories.length);
  }
}

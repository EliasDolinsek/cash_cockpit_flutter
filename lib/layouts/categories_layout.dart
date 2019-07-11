import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/category_item.dart';

import '../core/category.dart';

import '../data/data_provider.dart';
import '../data/data_manager.dart' as dataManager;

class CategoriesLayout extends StatelessWidget {

  final bool editMode;
  final Function onCategorySelected;

  const CategoriesLayout({this.editMode = false, this.onCategorySelected(Category category)});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DataProvider.of(context).categories,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data.documents;
          if(documents.length == 0){
            return Center(
              child: Text("No cateogires"),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) {
                  final category =
                  Category.fromFirestore(documents.elementAt(index));
                  return CategoryItem(
                    category,
                    editMode: editMode,
                    onCategorySelected: onCategorySelected,
                  );
                },
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                ),
                itemCount: documents.length);
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

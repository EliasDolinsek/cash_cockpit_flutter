import 'package:flutter/material.dart';

import '../layouts/categories_layout.dart';

import '../core/category.dart';

import '../data/data_provider.dart';
import '../data/data_manager.dart' as dataManager;

class CategoriesEditorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          MaterialButton(
            child: Text("ADD NEW"),
            onPressed: () => _addCategory(context),
          )
        ],
      ),
      body: CategoriesLayout(
        editMode: true,
      ),
    );
  }

  void _addCategory(BuildContext context){
    dataManager.createCategory(Category.newCategory(), DataProvider.of(context).firebaseUser.uid);
  }
}

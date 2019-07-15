import 'package:flutter/material.dart';

import '../layouts/categories_layout.dart';

class SelectCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SELECT CATEGORY", style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: CategoriesLayout(
        onCategorySelected: (category) {
          Navigator.of(context).pop(category);
        },
      ),
    );
  }
}

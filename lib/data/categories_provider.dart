import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/category.dart';

class CategoriesProvider {

  final Stream<QuerySnapshot> categoriesStream;
  final List<Category> categoeries = List<Category>();
  Function onChanged;

  CategoriesProvider(this.categoriesStream) {
    categoriesStream.listen((snapshot) {
      categoeries.clear();

      categoeries.addAll(
        snapshot.documents
            .map((document) => Category.fromFirestore(document))
            .toList(),
      );

      if (onChanged != null) onChanged();
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'bill.dart';

class Category {

  String name, color, id;
  List<String> billIDs;

  Category({this.name, this.color, this.billIDs, this.id});

  Color get usableColor => Color(int.parse(color));

  factory Category.newCategory(){
    return Category(name: "New Category", color: Colors.blue.value.toString(), billIDs: []);
  }

  factory Category.fromFirestore(DocumentSnapshot documentSnapshot){
    final map = documentSnapshot.data;
    if(map == null) return Category();

    return Category(
      id: documentSnapshot.documentID,
      name: map["name"] ?? "",
      color: map["color"] ?? "",
      billIDs: List<String>.from(map["billIDs"]) ?? []
    );
  }

  static List<Bill> getBillsOfCategory(Category category, List<Bill> bills) {
    return bills.where((b) => category.billIDs.contains(b.id)).toList();
  }

  Map<String, dynamic> toMap(String firebaseUserID) {
    return {
      "name":name,
      "color":color,
      "billIDs":billIDs,
      "userID": firebaseUserID
    };
  }

  static List<Category> getDefaultCategories() => [
    Category(name: "Default category #1", color: Colors.blue.value.toString(), billIDs: []),
    Category(name: "Default category #2", color: Colors.blue.value.toString(), billIDs: []),
    Category(name: "Default category #3", color: Colors.blue.value.toString(), billIDs: []),
  ];
}
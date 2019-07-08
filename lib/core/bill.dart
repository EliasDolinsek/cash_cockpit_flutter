import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {

  static const output = 0;
  static const input = 1;

  String name, month, id;
  List<String> imageURLs;
  int billType;
  double amount;

  Bill({this.name, this.month, this.imageURLs, this.billType, this.amount, this.id});

  factory Bill.fromnFirestore(DocumentSnapshot documentSnapshot){
    final map = documentSnapshot.data;
    return Bill(
      name: map["name"] ?? "",
      imageURLs: List<String>.from(map["imageURLs"]) ?? [],
      amount: map["amount"] ?? 0.0,
      billType: map["billType"] ?? output,
      month: map["month"] ?? "",
      id: documentSnapshot.documentID
    );
  }

  Map<String, dynamic> toMap(String firebaseUserID){
    return {
      "userID":firebaseUserID,
      "name":name,
      "month":month,
      "imageURLs":imageURLs,
      "billType":billType,
      "amount":amount,
    };
  }
}
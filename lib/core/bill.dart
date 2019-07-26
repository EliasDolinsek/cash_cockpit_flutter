import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  static const outcome = 0;
  static const income = 1;

  String name, month, id;
  List<String> imageURLs;
  int billType;
  double amount;

  Bill(
      {this.name,
      this.month,
      this.imageURLs,
      this.billType,
      this.amount,
      this.id});

  factory Bill.newBill(String month) {
    return Bill(
        name: "", month: month, imageURLs: [], billType: outcome, amount: 0.0);
  }

  factory Bill.fromnFirestore(DocumentSnapshot documentSnapshot) {
    final map = documentSnapshot.data;
    return Bill(
        name: map["name"] ?? "",
        imageURLs: List<String>.from(map["imageURLs"]) ?? [],
        amount: map["amount"] ?? 0.0,
        billType: map["billType"] ?? outcome,
        month: map["month"] ?? "",
        id: documentSnapshot.documentID);
  }

  static String billTypeAsString(int type) => type == outcome ? "OUTCOME" : "INCOME";

  Map<String, dynamic> toMap(String firebaseUserID) {
    return {
      "userID": firebaseUserID,
      "name": name,
      "month": month,
      "imageURLs": imageURLs,
      "billType": billType,
      "amount": amount,
    };
  }

  static double getBillsTotalAmount(List<Bill> bills) {
    double result = 0;
    bills.forEach((bill) => result += bill.amount);
    return result;
  }

  static List<Bill> filterBillsByType(List<Bill> bills, int billType) => bills.where((bill) => bill.billType == billType).toList();
}

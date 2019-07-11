import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MonthDataProvider {

  DateTime month;
  String firebaseUserID;
  Stream<QuerySnapshot> bills;

  MonthDataProvider({this.month, this.firebaseUserID}){
    setupMonth(month);
  }

  void setupMonth(DateTime month){
    this.month = month;
    bills = Firestore.instance.collection("bills").where("userID", isEqualTo: firebaseUserID).where("month", isEqualTo: monthAsString).snapshots();
  }

  String get monthAsString => DateFormat("MMM yyyy").format(month).toUpperCase();
}
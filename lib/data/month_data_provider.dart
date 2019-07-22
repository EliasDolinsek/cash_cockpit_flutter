import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../core/bill.dart';

class MonthDataProvider {

  DateTime month;
  String firebaseUserID;
  Stream<QuerySnapshot> billsStream;

  List<Bill> bills;
  Function onMonthChanged, onBillsChanged, onChange;

  MonthDataProvider({this.month, this.firebaseUserID, this.onMonthChanged}){
    setupMonth(month);
  }

  void setupMonth(DateTime month){
    this.month = month;
    billsStream = Firestore.instance.collection("bills").where("userID", isEqualTo: firebaseUserID).where("month", isEqualTo: monthAsString).snapshots();
    billsStream.listen((QuerySnapshot snapshot){
      bills = snapshot.documents.map((document) => Bill.fromnFirestore(document)).toList();
      if(onBillsChanged != null) onBillsChanged();
      if(onChange != null) onChange();
    });

    if(onMonthChanged != null) onMonthChanged();
    if(onChange != null) onChange();
  }

  List<Bill> get incomeBills => bills.where((bill) => bill.billType == Bill.income).toList() ?? [];
  List<Bill> get outcomeBills => bills.where((bill) => bill.billType == Bill.outcome).toList() ?? [];

  String get monthAsString => DateFormat("MMM yyyy").format(month).toUpperCase();
}
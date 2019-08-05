import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../core/bill.dart';

class MonthDataProvider {

  final String firebaseUserID;

  DateTime month;
  Stream<QuerySnapshot> billsStream;

  MonthDataProvider({this.month, this.firebaseUserID}) {
    setupMonth(month);
  }

  void setupMonth(DateTime month) {
    this.month = month;
    billsStream = Observable(Firestore.instance
        .collection("bills")
        .where("userID", isEqualTo: firebaseUserID)
        .where("month", isEqualTo: monthAsString)
        .snapshots()).shareReplay(maxSize: 1);
  }

  Stream<List<Bill>> get bills {
    return billsStream.map((snapshot) => snapshot.documents
        .map((document) => Bill.fromnFirestore(document))
        .toList());
  }

  String get monthAsString =>
      DateFormat("MMM yyyy").format(month).toUpperCase();
}

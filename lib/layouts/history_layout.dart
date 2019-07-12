import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/bill.dart';
import '../data/data_provider.dart';
import '../widgets/bill_item.dart';
import '../pages/bill_page.dart';

class HistoryLayout extends StatefulWidget {

  const HistoryLayout({Key key}) : super(key: key);

  @override
  _HistoryLayoutState createState() => _HistoryLayoutState();
}

class _HistoryLayoutState extends State<HistoryLayout> {

  DateTime month;

  @override
  Widget build(BuildContext context) {
    DataProvider.of(context).monthDataProvider.onMonthChanged = () => setState((){});
    return StreamBuilder<QuerySnapshot>(
      stream: DataProvider.of(context).monthDataProvider.bills,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildBillsList(snapshot.data.documents.length, snapshot);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildBillsList(int bills, AsyncSnapshot snapshot) {
    if(bills == 0){
      return Center(
        child: Text("No bills"),
      );
    } else {
      return ListView.separated(
        itemBuilder: (context, index) {
          final bill =
          Bill.fromnFirestore(snapshot.data.documents.elementAt(index));
          return BillItem(bill, onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillPage(bill, true)));
          },);
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: snapshot.data.documents.length,
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/bill.dart';
import '../data/data_provider.dart';
import '../widgets/bill_item.dart';
import '../pages/bill_page.dart';

class HistoryLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DataProvider.of(context).monthDataProvider.bills,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final bill =
                  Bill.fromnFirestore(snapshot.data.documents.elementAt(index));
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BillItem(bill, onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillPage(bill, true)));
                },),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: snapshot.data.documents.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

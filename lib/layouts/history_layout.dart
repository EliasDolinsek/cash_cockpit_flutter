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
    return _buildBillsList(DataProvider.of(context).monthDataProvider.bills);
  }

  Widget _buildBillsList(List<Bill> bills) {
    if(bills.length == 0){
      return Center(
        child: Text("No bills"),
      );
    } else {
      return ListView.separated(
        itemBuilder: (context, index) {
          final bill = bills.elementAt(index);
          return BillItem(bill, onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillPage(bill, true)));
          },);
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: bills.length,
      );
    }
  }
}

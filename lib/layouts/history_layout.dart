import 'package:flutter/material.dart';

import '../data/data_provider.dart';
import '../widgets/bill_item.dart';
import '../pages/bill_page.dart';

class HistoryLayout extends StatelessWidget {

  const HistoryLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataProvider.of(context).monthDataProvider.bills,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            final bills = snapshot.data;
            if(bills.length == 0){
              return Center(child: Text("No bills"));
            } else {
              return ListView.separated(
                itemBuilder: (context, index) {
                  final bill = bills.elementAt(index);
                  return BillItem(
                    bill,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BillPage(bill, true)));
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: bills.length,
              );
            }
          } else {
            return Center(
              child: Text("No data"),
            );
          }
        }
      },
    );
  }
}

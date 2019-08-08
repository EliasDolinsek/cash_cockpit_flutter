import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/bill_item.dart';
import '../pages/bill_page.dart';

class HistoryLayout extends StatelessWidget {

  final DataProvider dataProvider;

  const HistoryLayout({Key key, this.dataProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final bill = dataProvider.bills.elementAt(index);
        return BillItem(
          bill,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BillPage(bill, true, dataProvider)));
          },
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: dataProvider.bills.length,
    );
  }
}

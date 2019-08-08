import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:cash_cockpit_app/pages/bill_page.dart';
import 'package:flutter/material.dart';

import '../layouts/money_statistics_card.dart';
import '../layouts/bills_statistics_card.dart';
import '../layouts/categories_statistics_card.dart';

import '../data/config_provider.dart';

class HomeLayout extends StatelessWidget {

  final DataProvider dataProvider;

  const HomeLayout({Key key, this.dataProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          MoneyStatisticsCard(
            bills: dataProvider.bills,
            settings: ConfigProvider.of(context).settings,
          ),
          BillsStatisticsCard(
            bills: dataProvider.bills,
          ),
          CategoriesStatisticsCard(
            dataProvider: dataProvider,
          )
        ],
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final bill = Bill.newBill(dataProvider.monthAsString);
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => BillPage(bill, false, dataProvider)),
            );
          },
          label: Text("ADD BILL")),
    );
  }
}

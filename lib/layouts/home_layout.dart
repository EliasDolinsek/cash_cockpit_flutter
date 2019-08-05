import 'package:flutter/material.dart';

import '../layouts/money_statistics_card.dart';
import '../layouts/bills_statistics_card.dart';
import '../layouts/categories_statistics_card.dart';

import '../data/data_provider.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataProvider.of(context).categories,
      builder: (context, categoriesSnapshot) {
        return StreamBuilder(
          stream: DataProvider.of(context).monthDataProvider.bills,
          builder: (context, billsSnapshot) {
            if (categoriesSnapshot.connectionState == ConnectionState.waiting ||
                billsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (categoriesSnapshot.hasData && billsSnapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    MoneyStatisticsCard(
                      bills: billsSnapshot.data,
                      settings: DataProvider.of(context).settings,
                    ),
                    BillsStatisticsCard(
                      bills: billsSnapshot.data,
                    ),
                    CategoriesStatisticsCard(
                      categories: categoriesSnapshot.data,
                      bills: billsSnapshot.data,
                    )
                  ],
                );
              } else {
                return Center(child: Text("No statistics available"));
              }
            }
          },
        );
      },
    );
  }
}

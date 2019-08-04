import 'package:flutter/material.dart';

import '../layouts/money_statistics_card.dart';
import '../layouts/bills_statistics_card.dart';
import '../layouts/categories_statistics_card.dart';

import '../data/data_provider.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        MoneyStatisticsCard(),
        BillsStatisticsCard(),
        FutureBuilder(
          future: DataProvider.of(context).categories.first,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return CategoriesStatisticsCard(
                categories: snapshot.data,
                bills: DataProvider.of(context).monthDataProvider.bills,
              );
            } else {
              return Text("Loading categories statistics...");
            }
          },
        )
      ],
    );
  }
}

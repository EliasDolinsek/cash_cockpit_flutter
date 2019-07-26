import 'package:flutter/material.dart';

import '../layouts/money_statistics_card.dart';
import '../layouts/bills_statistics_card.dart';
import '../layouts/categories_statistics_card.dart';

import '../data/data_provider.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      DataProvider.of(context).monthDataProvider.onMonthChanged = () {
        setState(() {});
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        MoneyStatisticsCard(),
        BillsStatisticsCard(),
        CategoriesStatisticsCard()
      ],
    );
  }
}

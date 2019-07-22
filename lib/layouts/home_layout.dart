import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../layouts/bills_statistics_card.dart';

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
        BillsStatisticsCard()
      ],
    );
  }
}

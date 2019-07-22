import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'statistics_card.dart';

import '../core/bill.dart';
import '../data/data_provider.dart';

class BillsStatisticsCard extends StatefulWidget {
  @override
  _BillsStatisticsCardState createState() => _BillsStatisticsCardState();
}

class _BillsStatisticsCardState extends State<BillsStatisticsCard> {
  DefaultStatisticsOptions _selectedStatisticOption;

  @override
  void initState() {
    super.initState();
    _selectedStatisticOption = DefaultStatisticsOptions.amountBased;
    Future.delayed(Duration.zero, () {
      DataProvider.of(context).monthDataProvider.onChange =
          () => setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatisticsCard(
      title: Text(
        "Bills",
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 0.0,
        ),
        textAlign: TextAlign.left,
      ),
      options: Row(
        children: <Widget>[
          ChoiceChip(
            label: Text("AMOUNT BASED"),
            selected: _selectedStatisticOption ==
                DefaultStatisticsOptions.amountBased,
            onSelected: (value) {
              setState(() {
                _selectedStatisticOption = DefaultStatisticsOptions.amountBased;
              });
            },
          ),
          SizedBox(width: 8.0),
          ChoiceChip(
            label: Text("USAGE BASED"),
            selected:
                _selectedStatisticOption == DefaultStatisticsOptions.usageBased,
            onSelected: (value) {
              setState(() {
                _selectedStatisticOption = DefaultStatisticsOptions.usageBased;
              });
            },
          ),
        ],
      ),
      statistic: Center(
        child: Container(
          width: 300,
          height: 300,
          child: charts.PieChart(
            _getChartSeries(),
            defaultRenderer: charts.ArcRendererConfig(arcWidth: 60),
          ),
        ),
      ),
    );
  }

  List<charts.Series<BillTypeUsage, int>> _getChartSeries() {
    return [
      charts.Series<BillTypeUsage, int>(
          id: "Bill usage",
          domainFn: (BillTypeUsage usage, _) => usage.billType,
          measureFn: (BillTypeUsage usage, _) => usage.usage,
          data: billTypeUsageAsList(),
          colorFn: (usage, _) => usage.billType == Bill.income
              ? charts.MaterialPalette.green.shadeDefault
              : charts.MaterialPalette.red.shadeDefault)
    ];
  }

  List<BillTypeUsage> billTypeUsageAsList() {
    final dataProvider = DataProvider.of(context);
    if (_selectedStatisticOption == DefaultStatisticsOptions.amountBased) {
      return [
        BillTypeUsage(
            Bill.outcome,
            getAmountResultFromBills(
                dataProvider.monthDataProvider.outcomeBills)),
        BillTypeUsage(
            Bill.income,
            getAmountResultFromBills(
                dataProvider.monthDataProvider.incomeBills)),
      ];
    } else {
      return [
        BillTypeUsage(
            Bill.outcome, dataProvider.monthDataProvider.outcomeBills.length),
        BillTypeUsage(
            Bill.income, dataProvider.monthDataProvider.incomeBills.length),
      ];
    }
  }

  int getAmountResultFromBills(List<Bill> bills) {
    double result = 0;
    bills.forEach((bill) => result += bill.amount);
    return result.toInt();
  }
}

class BillTypeUsage {
  final int billType;
  final int usage;

  const BillTypeUsage(this.billType, this.usage);
}

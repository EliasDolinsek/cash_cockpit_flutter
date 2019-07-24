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
      final dataProvider = DataProvider.of(context);
      dataProvider.monthDataProvider.onChange = () => setState(() {});
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
            Bill.getBillsTotalAmount(
                dataProvider.monthDataProvider.outcomeBills)),
        BillTypeUsage(
            Bill.income,
            Bill.getBillsTotalAmount(
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
}

class BillTypeUsage {
  final int billType;
  final int usage;

  const BillTypeUsage(this.billType, this.usage);
}

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'statistics_card.dart';

import '../core/bill.dart';

class BillsStatisticsCard extends StatefulWidget {

  final List<Bill> bills;

  List<Bill> get outcomeBills => Bill.filterBillsByType(bills, Bill.outcome);
  List<Bill> get incomeBills => Bill.filterBillsByType(bills, Bill.income);

  const BillsStatisticsCard({Key key, @required this.bills}) : super(key: key);

  @override
  _BillsStatisticsCardState createState() => _BillsStatisticsCardState();
}

class _BillsStatisticsCardState extends State<BillsStatisticsCard> {
  DefaultStatisticsOptions _selectedStatisticOption;

  @override
  void initState() {
    super.initState();
    _selectedStatisticOption = DefaultStatisticsOptions.amountBased;
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
          child: _buildStatistic(),
        ),
      ),
    );
  }

  Widget _buildStatistic(){
    if(widget.bills == null || widget.bills.length == 0 || Bill.getBillsTotalAmount(widget.bills) == 0){
      return Center(child: Text("No statistic available"));
    } else {
      return charts.PieChart(
        _getChartSeries(),
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [charts.ArcLabelDecorator()],
        ),
      );
    }
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
              : charts.MaterialPalette.red.shadeDefault,
          labelAccessorFn: (BillTypeUsage usage, _) =>
              Bill.billTypeAsString(usage.billType)),
    ];
  }

  List<BillTypeUsage> billTypeUsageAsList() {
    if (_selectedStatisticOption == DefaultStatisticsOptions.amountBased) {
      return [
        BillTypeUsage(
            Bill.outcome,
            Bill.getBillsTotalAmount(
                widget.outcomeBills).toInt()),
        BillTypeUsage(
            Bill.income,
            Bill.getBillsTotalAmount(
                widget.incomeBills).toInt()),
      ];
    } else {
      return [
        BillTypeUsage(
            Bill.outcome, widget.outcomeBills.length),
        BillTypeUsage(
            Bill.income, widget.incomeBills.length),
      ];
    }
  }
}

class BillTypeUsage {
  final int billType;
  final int usage;

  const BillTypeUsage(this.billType, this.usage);
}

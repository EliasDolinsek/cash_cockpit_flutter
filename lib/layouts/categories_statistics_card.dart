import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../core/category.dart';
import '../core/bill.dart';

import 'statistics_card.dart';

class CategoriesStatisticsCard extends StatefulWidget {

  final DataProvider dataProvider;

  const CategoriesStatisticsCard({Key key, this.dataProvider}) : super(key: key);


  List<Category> get usableCategories =>
      dataProvider.categories.where((c) => c.billIDs.where((billID) => Bill.findBill(billID, dataProvider.bills) != null).toList().length != 0).toList();

  List<Category> get usableAmountBasedCategories => usableCategories
      .where((c) =>
          Bill.getBillsTotalAmount(Category.getBillsOfCategory(c, dataProvider.bills)) != 0)
      .toList();

  @override
  _CategoriesStatisticsCardState createState() =>
      _CategoriesStatisticsCardState();
}

class _CategoriesStatisticsCardState extends State<CategoriesStatisticsCard> {
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
        "Categories",
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

  Widget _buildStatistic() {
    if (_canBuildStatistics()) {
      return charts.PieChart(
        _getChartSeries(),
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [charts.ArcLabelDecorator()],
        ),
      );
    } else {
      return Center(child: Text("No statistic available"));
    }
  }

  bool _canBuildStatistics() =>
      widget.dataProvider.categories != null && widget.usableCategories != null && widget.dataProvider.bills != null &&
      ((_selectedStatisticOption == DefaultStatisticsOptions.amountBased &&
              _canBuildAmountBasedStatistics()) ||
          (_selectedStatisticOption == DefaultStatisticsOptions.usageBased &&
              _canBuildUsageBasedStatistics()));

  bool _canBuildAmountBasedStatistics() =>
      widget.usableCategories != null &&
      widget.usableAmountBasedCategories != null &&
      widget.usableAmountBasedCategories.length != 0;

  bool _canBuildUsageBasedStatistics() =>
      widget.usableCategories != null && widget.usableCategories.length != 0;

  List<charts.Series<CategoryUsage, int>> _getChartSeries() {
    return [
      charts.Series<CategoryUsage, int>(
        id: "Categories usage",
        domainFn: (CategoryUsage usage, _) => _,
        measureFn: (CategoryUsage usage, _) => usage.usage,
        data: categoriesUsageAsList(),
        colorFn: (usage, _) => charts.Color(
            r: usage.category.usableColor.red,
            g: usage.category.usableColor.green,
            b: usage.category.usableColor.blue),
        labelAccessorFn: (CategoryUsage usage, _) => usage.category.name,
      ),
    ];
  }

  List<CategoryUsage> categoriesUsageAsList() {
    if (_selectedStatisticOption == DefaultStatisticsOptions.amountBased) {
      return categoriesUsageAmountBasedAsList();
    } else {
      return widget.usableCategories
          .map((c) => CategoryUsage(c, c.billIDs.length))
          .toList();
    }
  }

  List<CategoryUsage> categoriesUsageAmountBasedAsList() {
    return widget.usableAmountBasedCategories
        .map((category) => CategoryUsage(
            category,
            Bill.getBillsTotalAmount(
                    Category.getBillsOfCategory(category, widget.dataProvider.bills))
                .toInt()))
        .toList();
  }
}

class CategoryUsage {
  Category category;
  int usage;

  CategoryUsage(this.category, this.usage);
}

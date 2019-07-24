import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../core/category.dart';
import '../core/bill.dart';

import '../data/data_provider.dart';
import 'statistics_card.dart';

class CategoriesStatisticsCard extends StatefulWidget {
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
    Future.delayed(Duration.zero, () {
      final dataProvider = DataProvider.of(context);
      dataProvider.monthDataProvider.onChange = () => setState(() {});
      dataProvider.categoriesProvider.onChanged = () => setState((){});
    });
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
        /*
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
         */
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
      )
    ];
  }

  List<CategoryUsage> categoriesUsageAsList() {
    final dataProvider = DataProvider.of(context);
    if (_selectedStatisticOption == DefaultStatisticsOptions.amountBased) {
      return categoriesUsageAmountBasedAsList(
          dataProvider.categoriesProvider.categoeries,
          dataProvider.monthDataProvider.bills);
    } else if (_selectedStatisticOption ==
        DefaultStatisticsOptions.usageBased) {
      return dataProvider.categoriesProvider.categoeries
          .map((c) => CategoryUsage(c, c.billIDs.length))
          .toList();
    }
  }

  List<CategoryUsage> categoriesUsageAmountBasedAsList(
      List<Category> categories, List<Bill> usableBills) {
    return categories
        .map((category) => CategoryUsage(
            category,
            Bill.getBillsTotalAmount(
                filterBillsOfCategory(category, usableBills))))
        .toList();
  }

  List<Bill> filterBillsOfCategory(Category category, List<Bill> bills) {
    return bills.where((b) => category.billIDs.contains(b.id)).toList();
  }
}

class CategoryUsage {
  Category category;
  int usage;

  CategoryUsage(this.category, this.usage);
}

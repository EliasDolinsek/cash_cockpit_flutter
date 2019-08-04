import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import 'statistics_card.dart';
import '../widgets/amount_text.dart';
import '../data/data_calculator.dart' as dataCalculator;

class MoneyStatisticsCard extends StatelessWidget {

  final defaultTextsStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.15);

  @override
  Widget build(BuildContext context) {
    final bills = DataProvider.of(context).monthDataProvider.bills;
    final settings = DataProvider.of(context).settings;
    final currencyFormatter =
        DataProvider.of(context).settings.currencyFormatter;

    return StatisticsCard(
      statistic: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AmountText(
              amount: dataCalculator.calculateCash(bills, settings),
              lowerText: "CASH",
              redWhenNegative: true,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          ListTile(
            title: Text("Daily limit", style: defaultTextsStyle),
            trailing: Text(
              currencyFormatter.formatAmount(
                  dataCalculator.calculateDailyLimit(bills, settings)),
              style: defaultTextsStyle,
            ),
          ),
          ListTile(
            title: Text("Credit Rate", style: defaultTextsStyle),
            trailing: Text(
              currencyFormatter
                  .formatAmount(dataCalculator.calculateCreditRate(bills, settings)),
              style: defaultTextsStyle,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          _buildBalanceNotice(context)
        ],
      ),
    );
  }

  Widget _buildBalanceNotice(BuildContext context) {
    final dataProvider = DataProvider.of(context);
    final balance = dataProvider.settings.currencyFormatter
        .formatAmount(dataProvider.settings.balance);
    final monthlySaveUps = dataProvider.settings.currencyFormatter.formatAmount(dataProvider.settings.desiredMonthlySaveUps);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Based on a total balance of $balance and desired monthly savups of $monthlySaveUps", textAlign: TextAlign.justify,),
        ),
        MaterialButton(
          child: Text("CHANGE"),
          onPressed: () {},
        )
      ],
    );
  }
}

import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/core/settings.dart';
import 'package:cash_cockpit_app/pages/statistics_settings_page.dart';
import 'package:flutter/material.dart';

import 'statistics_card.dart';
import '../widgets/amount_text.dart';
import '../data/data_calculator.dart' as dataCalculator;

class MoneyStatisticsCard extends StatelessWidget {
  final List<Bill> bills;
  final Settings settings;

  final defaultTextsStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.15);

  MoneyStatisticsCard({Key key, @required this.bills, @required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatisticsCard(
      statistic: _buildStatistic(context),
    );
  }

  Widget _buildStatistic(BuildContext context) {
    final currencyFormatter = settings.currencyFormatter;
    if (bills != null && bills.length != 0) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AmountText(
              settings,
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
              currencyFormatter.formatAmount(
                  dataCalculator.calculateCreditRate(bills, settings)),
              style: defaultTextsStyle,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          _buildBalanceNotice(context)
        ],
      );
    } else {
      return Center(
        child: Container(
          width: 300,
          height: 300,
          child: Center(
            child: Text("No statistics available"),
          ),
        ),
      );
    }
  }

  Widget _buildBalanceNotice(BuildContext context) {
    final balance = settings.currencyFormatter.formatAmount(settings.balance);
    final monthlySaveUps =
        settings.currencyFormatter.formatAmount(settings.desiredMonthlySaveUps);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Based on a total balance of $balance and desired monthly savups of $monthlySaveUps",
            textAlign: TextAlign.justify,
          ),
        ),
        MaterialButton(
          child: Text("CHANGE"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => StatisticsSettingsPage()),
            );
          },
        )
      ],
    );
  }
}

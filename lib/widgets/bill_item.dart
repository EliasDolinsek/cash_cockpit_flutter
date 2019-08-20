import 'package:cash_cockpit_app/core/core.dart';
import 'package:flutter/material.dart';

import '../core/bill.dart';

class BillItem extends StatelessWidget {

  final Bill bill;
  final Function onPressed;
  final Settings settings;

  const BillItem(this.bill, this.settings, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = settings.currencyFormatter;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  bill.name.isNotEmpty ? bill.name : "No name",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  currencyFormatter.formatAmount(bill.amount),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.15),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Chip(
                  label: Text(
                    Bill.billTypeAsString(bill.billType),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: bill.billType == Bill.outcome ? Color(0xFF9a0007) : Color(0xFF00600f),
                ),
                SizedBox(width: 8.0),
                Chip(
                  label: Text("${bill.imageURLs.length} IMAGES",
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

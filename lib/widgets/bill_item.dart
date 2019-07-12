import 'package:flutter/material.dart';

import '../core/bill.dart';

import '../data/data_provider.dart';

class BillItem extends StatelessWidget {
  final Bill bill;
  final Function onPressed;

  const BillItem(this.bill, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        DataProvider.of(context).settings.currencyFormatter;
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
                    bill.billTypeAsString,
                    style: TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8.0),
                Chip(
                  label: Text("${bill.imageURLs.length} images",
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

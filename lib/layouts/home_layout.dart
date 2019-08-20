import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:cash_cockpit_app/pages/bill_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../layouts/money_statistics_card.dart';
import '../layouts/bills_statistics_card.dart';
import '../layouts/categories_statistics_card.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<DataBloc>(context),
      builder: (context, state){
        if(state is DataAvailableState){
          return Scaffold(
            body: ListView(
              children: <Widget>[
                MoneyStatisticsCard(
                    bills: state.bills,
                    settings: state.settings
                ),
                BillsStatisticsCard(
                  bills: state.bills,
                ),
                CategoriesStatisticsCard(
                    bills: state.bills,
                    categories: state.categories
                )
              ],
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  final bill = Bill.newBill(state.monthAsString);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BillPage(bill, false, state.categories, state.settings)),
                  );
                },
                label: Text("ADD BILL")),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

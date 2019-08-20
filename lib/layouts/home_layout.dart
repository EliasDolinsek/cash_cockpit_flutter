import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/data/blocs/blocs.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:cash_cockpit_app/pages/bill_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../layouts/money_statistics_card.dart';
import '../layouts/bills_statistics_card.dart';
import '../layouts/categories_statistics_card.dart';

import '../data/config_provider.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: BlocProvider.of<DataBloc>(context),
        builder: (context, state){
          if(state is DataAvailableState){
            return ListView(
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final bill = Bill.newBill("MONTH_AS_STRING"); //TODO Add month as string
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => BillPage(bill, false, null)), //TODO replace null with data
            );
          },
          label: Text("ADD BILL")),
    );
  }
}

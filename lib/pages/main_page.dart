import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../core/bill.dart';

import '../pages/bill_page.dart';

import '../layouts/history_layout.dart';
import '../layouts/settings_layout.dart';

import '../data/data_provider.dart';
import '../data/data_manager.dart' as dataManager;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bodies = [
    Text("HOME"),
    HistoryLayout(),
    SettingsLayout(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CashCockpit",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            child: InkWell(
              onTap: _showMonthPicker,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: [
                    DropdownMenuItem(child: Text(DataProvider.of(context).monthDataProvider.monthAsString)),
                    DropdownMenuItem(
                      child: Text("CHANGE"),
                      value: "change",
                    )
                  ],
                  onChanged: (value) {
                    if (value == "change") _showMonthPicker();
                  },
                ),
              ),
            ),
          )
        ],
      ),
      body: _bodies.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Container(),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                final bill = Bill.newBill(DataProvider.of(context).monthDataProvider.monthAsString);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillPage(bill, false)));
              },
              label: Text("ADD BILL"))
          : null,
    );
  }

  void _showMonthPicker() {
    showMonthPicker(
      context: context,
      initialDate: DataProvider.of(context).monthDataProvider.month,
    ).then((DateTime dateTime) {
      if(dateTime == null) return;
      setState(() {
        DataProvider.of(context).monthDataProvider.setupMonth(dateTime);
      });
    });
  }
}

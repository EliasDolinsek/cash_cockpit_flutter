import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../layouts/home_layout.dart';
import '../layouts/history_layout.dart';
import '../layouts/settings_layout.dart';

import '../data/config_provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final _bodies = [
    HomeLayout(),
    HistoryLayout(),
    SettingsLayout(),
  ];

  int _selectedIndex = 0;

  DataProvider month;

  @override
  Widget build(BuildContext context) {
    final userID = ConfigProvider.of(context).userID;
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
                    DropdownMenuItem(
                        child: Text(month.monthAsString)),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("categories")
            .where("userID", isEqualTo: userID)
            .snapshots(),
        builder: (context, categories){
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("bills")
                .where("userID", isEqualTo: userID)
                .where("month", isEqualTo: month.monthAsString)
                .snapshots(),
            builder: (context, bills){
              if(categories.connectionState == ConnectionState.waiting && bills.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              } else {
                if(categories.hasData && bills.hasData){
                  return _bodies.elementAt(_selectedIndex);
                } else {
                  return Center(child: Text("No data"));
                }
              }
            },
          );
        },
      ),
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
    );
  }

  void _showMonthPicker() {
    showMonthPicker(
      context: context,
      initialDate: month.month,
    ).then((DateTime dateTime) {
      if (dateTime == null) return;
      setState(() {
        month.month = dateTime;
      });
    });
  }
}

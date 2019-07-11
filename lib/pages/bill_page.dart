import 'package:cash_cockpit_app/core/category.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/bill.dart';

import '../layouts/categories_layout.dart';

import '../widgets/amount_text.dart';

import '../data/data_provider.dart';
import '../data/data_manager.dart' as dataManager;

class BillPage extends StatefulWidget {
  final Bill bill;
  final bool editMode;

  const BillPage(this.bill, this.editMode);

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int billType;
  double amount;
  String name;
  Category category;

  bool categoryLoading = false;

  @override
  void initState() {
    super.initState();
    billType = widget.bill.billType;
    amount = widget.bill.amount;
    name = widget.bill.name;
  }

  void loadCategoryFromFirestore() async {
    if (widget.bill.id == null || widget.bill.id.isEmpty) {
    } else {
      setState(() => categoryLoading = true);
      final documentReference = (await Firestore.instance
              .collection("categories")
              .where("billIDs", arrayContains: widget.bill.id)
              .snapshots()
              .first)
          .documents
          .first;

      setState(() {
        category = Category.fromFirestore(documentReference);
        categoryLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: _buildActions(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AmountText(
                    upperText: amount.toString(),
                    lowerText: "Amount",
                    editable: true,
                    onTextChanged: null,
                  ),
                  SizedBox(height: 16.0),
                  _buildBillTypeSelection(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: <Widget>[
                  _buildNameField(),
                  SizedBox(height: 8.0),
                  _buildCategoryListTitle(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ChoiceChip(
          avatar: CircleAvatar(
            child: Text("+"),
          ),
          label: Text("INCOME"),
          selected: billType == Bill.income,
          onSelected: (value) {
            setState(() {
              billType = Bill.income;
            });
          },
        ),
        SizedBox(width: 16.0),
        ChoiceChip(
          avatar: CircleAvatar(
            child: Text("-"),
          ),
          label: Text("OUTCOME"),
          selected: billType == Bill.outcome,
          onSelected: (value) {
            setState(() {
              billType = Bill.outcome;
            });
          },
        )
      ],
    );
  }

  List<Widget> _buildActions() {
    final firebaseUserID = DataProvider.of(context).firebaseUser.uid;
    if (widget.editMode) {
      return [
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            updateBill();
            dataManager.updateBill(widget.bill, firebaseUserID);
            if (category != null)
              dataManager.updateCategory(category, firebaseUserID);
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {},
        )
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            updateBill();
            dataManager
                .createBill(widget.bill, firebaseUserID)
                .then((billid) {

            });
            if (category != null)
              dataManager.updateCategory(category, firebaseUserID);
            Navigator.of(context).pop();
          },
        ),
      ];
    }
  }

  void updateBill() {
    widget.bill.name = name;
    widget.bill.billType = billType;
    widget.bill.amount = amount;
  }

  Widget _buildNameField() {
    return TextField(
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: "Name"),
      onChanged: (value) {
        setState(() {
          name = value;
        });
      },
    );
  }

  Widget _buildCategoryListTitle() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            category == null ? Colors.black : Color(int.parse(category.color)),
      ),
      title: Text(category == null ? "No category" : category.name),
      trailing: MaterialButton(
        onPressed: () {
          _scaffoldKey.currentState.showBottomSheet(
            (context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CategoriesLayout(
                  onCategorySelected: (category) {
                    Navigator.of(context).pop();
                    setState(() => this.category = category);
                  },
                ),
              );
            },
          );
        },
        child: Text("CHANGE"),
      ),
    );
  }
}

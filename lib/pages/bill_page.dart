import 'package:cash_cockpit_app/core/category.dart';
import 'package:cash_cockpit_app/data/data_provider.dart';
import 'package:flutter/material.dart';

import '../core/bill.dart';

import '../widgets/amount_text.dart';
import '../layouts/images_list.dart';

import 'select_category_page.dart';

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

  DataProvider _dataProvider;
  TextEditingController _nameController;

  int billType;
  double amount;
  String name;
  Category category;

  @override
  void initState() {
    super.initState();
    billType = widget.bill.billType;
    amount = widget.bill.amount;
    name = widget.bill.name;
    _nameController = TextEditingController(text: name)
      ..selection = TextSelection.collapsed(offset: name.length);

    Future.delayed(Duration.zero, () {
      _dataProvider = DataProvider.of(context);

      setState(() {
        category = DataProvider.of(context)
            .categoriesProvider
            .categoeries
            .firstWhere((c) => c.billIDs.contains(widget.bill.id),
                orElse: () => null);
      });
    });
  }

  @override
  void dispose() {
    if (widget.editMode) {
      updateBill();
      updateCategory(widget.bill.id);
    }

    super.dispose();
  }

  void updateCategory(String billID) {
    if (category != null) {
      print(category.billIDs);
      if (!category.billIDs.contains(billID)) category.billIDs.add(billID);
      dataManager.updateCategory(category, _dataProvider.firebaseUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(name.isNotEmpty ? name : "Bill",
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: _buildActions(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: AmountText(
                amount: amount,
                lowerText: "Amount",
                editable: true,
                autoFocus: true,
                onTextChanged: (value) {
                  amount = value;
                },
              ),
            ),
            Flexible(
                flex: 7,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    _buildBillTypeSelection(),
                    SizedBox(height: 16.0),
                    _buildNameField(),
                    SizedBox(height: 8.0),
                    _buildCategoryListTitle(),
                    SizedBox(height: 8.0),
                    Container(
                      child: ImagesList(widget.bill),
                      constraints: BoxConstraints(maxHeight: 100),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (widget.editMode) {
      return [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDeleteDialog();
          },
        )
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            updateBill();
            Navigator.pop(context);
          },
        )
      ];
    }
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

  void updateBill() {
    widget.bill.name = name;
    widget.bill.billType = billType;
    widget.bill.amount = amount;

    final firebaseUserID = _dataProvider.firebaseUser.uid;
    if (widget.editMode) {
      dataManager.updateBill(widget.bill, firebaseUserID);
    } else {
      dataManager
          .createBill(widget.bill, firebaseUserID)
          .then((billID) => updateCategory(billID));
    }
  }

  Widget _buildNameField() {
    return TextField(
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: "Name"),
      controller: _nameController,
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
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => SelectCategoryPage()))
              .then((category) {
            setState(() {
              this.category = category;
            });
          });
        },
        child: Text("CHANGE"),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete bill"),
        content: Text("Do you really want to delete this bill?"),
        actions: <Widget>[
          MaterialButton(
            child: Text("CANCEL"),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            child: Text("DELETE"),
            onPressed: () {
              dataManager.deleteBill(widget.bill);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
    );
  }
}

import 'package:cash_cockpit_app/core/bill.dart';
import 'package:cash_cockpit_app/core/category.dart';
import 'package:intl/intl.dart';

class DataProvider {

  List<Bill> bills;
  List<Category> categories;
  DateTime month;

  DataProvider(this.bills, this.categories, this.month);

  String get monthAsString =>
      DateFormat("MMM yyyy").format(month).toUpperCase();

}
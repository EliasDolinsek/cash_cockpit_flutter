import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cash_cockpit_app/core/core.dart';

@immutable
abstract class DataEvent extends Equatable {

  DataEvent([List props = const []]) : super(props);
  
}

class SetupDataEvent extends DataEvent {

  final DateTime month;

  SetupDataEvent(this.month) : super([month]);


}

class DataUpdatedEvent extends DataEvent {

  final List<Bill> bills;
  final List<Category> categories;
  final Settings settings;

  DataUpdatedEvent(this.bills, this.categories, this.settings) : super([bills, categories, settings]);
}

class CreateCategory extends DataEvent {
  
  final Category category;

  CreateCategory(this.category) : super([category]);
  
}

class UpdateCategory extends DataEvent {

  final Category category;

  UpdateCategory(this.category) : super([category]);
  
}

class DeleteCategory extends DataEvent {

  final Category category;

  DeleteCategory(this.category) : super([category]);
  
}

class CreateBill extends DataEvent {

  final Bill bill;

  CreateBill(this.bill) : super([bill]);
  
}

class UpdateBill extends DataEvent {

  final Bill bill;

  UpdateBill(this.bill) : super([bill]);

}

class DeleteBill extends DataEvent {

  final Bill bill;

  DeleteBill(this.bill) : super([bill]);

}

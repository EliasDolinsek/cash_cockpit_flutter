import 'package:cash_cockpit_app/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DataState extends Equatable {
  DataState([List props = const []]) : super(props);
}

class InitialDataState extends DataState {}

class DataLoadingState extends DataState {}

class DataAvailableState extends DataState {
  final List<Bill> bills;
  final List<Category> categories;
  final Settings settings;

  DataAvailableState([this.bills, this.categories, this.settings])
      : super([bills, categories, settings]);
}

class DataErrorState extends DataState {
  final String error;

  DataErrorState(this.error) : super([error]);
}

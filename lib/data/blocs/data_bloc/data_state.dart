import 'package:cash_cockpit_app/core/core.dart';
import 'package:cash_cockpit_app/data/blocs/data_bloc/data_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DataState extends Equatable {
  DataState([List props = const []]) : super(props);
}

class InitialDataState extends DataState {}

class DataLoadingState extends DataState {}

class DataAvailableState extends DataState {

  final DateTime month;
  final List<Bill> bills;
  final List<Category> categories;
  final Settings settings;

  DataAvailableState([this.bills, this.categories, this.settings, this.month])
      : super([bills, categories, settings, month]);

  String get monthAsString => DataBloc.monthAsString(month);
}

class DataErrorState extends DataState {
  final String error;

  DataErrorState(this.error) : super([error]);
}

class SetupSettingsState extends DataState {

  final Settings settings;

  SetupSettingsState(this.settings) : super([settings]);


}

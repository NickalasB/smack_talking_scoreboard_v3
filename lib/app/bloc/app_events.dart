import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {}

class LoadDefaultInsultsEvent extends AppEvent {
  LoadDefaultInsultsEvent({
    required this.defaultInsults,
    required this.defaultTieInsults,
  });

  final List<String> defaultInsults;
  final List<String> defaultTieInsults;

  @override
  List<Object?> get props => [defaultInsults, defaultTieInsults];
}

class LoadAvailableVoicesEvent extends AppEvent {
  LoadAvailableVoicesEvent();

  @override // coverage:ignore-line
  List<Object?> get props => []; // coverage:ignore-line
}

class SaveInsultEvent extends AppEvent {
  SaveInsultEvent(this.insult);
  final String? insult;

  @override
  List<Object?> get props => [insult];
}

class DeleteInsultEvent extends AppEvent {
  DeleteInsultEvent(this.insult);

  final String insult;
  @override
  List<Object?> get props => [insult];
}

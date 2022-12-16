import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {}

class LoadDefaultInsultsEvent extends AppEvent {
  LoadDefaultInsultsEvent({
    required this.defaultInsults,
  });

  final List<String> defaultInsults;

  @override
  List<Object?> get props => [defaultInsults];
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

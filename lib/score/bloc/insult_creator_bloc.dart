import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsultCreatorBloc extends Bloc<InsultCreatorEvent, InsultCreatorState> {
  InsultCreatorBloc() : super(InsultCreatorState('')) {
    final insultMap = <int, String>{};

    on<CreateInsultEvent>((event, emit) {
      _createInsult(insultMap, event, emit);
    });
  }

  void _createInsult(
    Map<int, String> insultMap,
    CreateInsultEvent event,
    Emitter<InsultCreatorState> emit,
  ) {
    insultMap.update(
      event.index,
      (value) => event.insult,
      ifAbsent: () => event.insult,
    );

    final fullInsultPhrase = List<String>.from(insultMap.values)
        .join(' ')
        .replaceAll('Hi/Low', r'$invalid$')
        .replaceAll('Hi', r'$Hi$')
        .replaceAll('Low', r'$Low$');

    emit(InsultCreatorState(fullInsultPhrase));
  }
}

abstract class InsultCreatorEvent extends Equatable {}

class CreateInsultEvent extends InsultCreatorEvent {
  CreateInsultEvent(this.insult, {required this.index});

  final String insult;
  final int index;

  @override
  List<Object?> get props => [insult];
}

class InsultCreatorState {
  InsultCreatorState(this.constructedInsult);

  String constructedInsult;
}

extension InsultCreatorContext on BuildContext {
  InsultCreatorBloc get readInsultCreator => read<InsultCreatorBloc>();

  InsultCreatorBloc get selectInsultCreator =>
      BlocProvider.of<InsultCreatorBloc>(this, listen: true);
}

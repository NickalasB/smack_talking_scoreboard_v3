import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const inValidKey = r'$invalid$';
const hiLowKey = r'$HI/LOW$';

class InsultCreatorBloc extends Bloc<InsultCreatorEvent, InsultCreatorState> {
  InsultCreatorBloc() : super(const InsultCreatorState('')) {
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
        .replaceAll(hiLowKey, inValidKey);

    emit(InsultCreatorState(fullInsultPhrase));
  }
}

abstract class InsultCreatorEvent extends Equatable {}

class CreateInsultEvent extends InsultCreatorEvent {
  CreateInsultEvent(this.insult, {required this.index});

  final String insult;
  final int index;

  @override
  List<Object?> get props => [insult, index];
}

class InsultCreatorState extends Equatable {
  const InsultCreatorState(this.constructedInsult);

  final String constructedInsult;

  @override
  List<Object?> get props => [constructedInsult];
}

extension InsultCreatorContext on BuildContext {
  InsultCreatorBloc get readInsultCreator => read<InsultCreatorBloc>();

  InsultCreatorBloc get selectInsultCreator =>
      BlocProvider.of<InsultCreatorBloc>(this, listen: true);
}

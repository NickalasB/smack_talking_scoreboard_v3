import 'package:bloc/bloc.dart';

class FakeBloc<Event, State> extends Bloc<Event, State> {
  FakeBloc(super.initialState);

  final addedEvents = <Event>[];

  @override
  void add(Event event) {
    addedEvents.add(event);
  }
}

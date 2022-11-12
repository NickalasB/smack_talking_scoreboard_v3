import 'package:hydrated_bloc/hydrated_bloc.dart';

class FakeBloc<Event, State> extends HydratedBloc<Event, State> {
  FakeBloc(super.initialState);

  final addedEvents = <Event>[];

  @override
  void add(Event event) {
    addedEvents.add(event);
  }

  @override
  State? fromJson(Map<String, dynamic> json) {
    return json['value'] as State;
  }

  @override
  Map<String, dynamic>? toJson(State state) {
    return {'value': state};
  }
}

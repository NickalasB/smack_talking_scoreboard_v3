import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<LoadDefaultInsultsEvent>(_loadDefaultInsults);

    on<SaveInsultEvent>(_saveInsult);

    on<DeleteInsultEvent>(_deleteInsult);
  }

  void _loadDefaultInsults(
    LoadDefaultInsultsEvent event,
    Emitter<AppState> emit,
  ) {
    final userAddedInsultsOnly = state.insults
        .where((insult) => !event.defaultInsults.contains(insult))
        .toList();

    final userModifiedDefaultInsults = event.defaultInsults
        .where((insult) => state.insults.contains(insult))
        .toList();

    final correctDefaultInsultsToUse = userModifiedDefaultInsults.isNotEmpty
        ? userModifiedDefaultInsults
        : event.defaultInsults;

    return emit(
      state.copyWith(
        insults: [
          ...userAddedInsultsOnly.toSet(),
          ...correctDefaultInsultsToUse.toSet(),
        ],
      ),
    );
  }

  void _saveInsult(SaveInsultEvent event, Emitter<AppState> emit) {
    if (event.insult != null && event.insult!.isNotEmpty) {
      final newState =
          state.copyWith(insults: [event.insult!, ...state.insults]);
      emit(newState);
    }
  }

  void _deleteInsult(DeleteInsultEvent event, Emitter<AppState> emit) {
    final insults = List<String>.from(state.insults)..remove(event.insult);
    emit(
      state.copyWith(insults: insults),
    );
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) => state.toJson();
}

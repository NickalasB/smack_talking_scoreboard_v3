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

    final correctDefaultInsultsToUse =
        _correctDefaultInsultsToUse(event.defaultInsults).toSet();

    return emit(
      state.copyWith(
        insults: [
          ...userAddedInsultsOnly.toSet(),
          ...correctDefaultInsultsToUse,
        ],
        originalDefaultInsults: event.defaultInsults,
        tieInsults: event.defaultTieInsults,
        didCompleteInitialLoad: true,
      ),
    );
  }

  List<String> _correctDefaultInsultsToUse(
    List<String> defaultInsults,
  ) {
    final userModifiedDefaultInsults = defaultInsults
        .where((insult) => !state.deletedDefaultInsults.contains(insult))
        .toList();

    if (!state.didCompleteInitialLoad) {
      return defaultInsults;
    } else {
      if (userModifiedDefaultInsults.isNotEmpty) {
        return userModifiedDefaultInsults;
      } else {
        return [];
      }
    }
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
    final originalDefaultInsults = state.originalDefaultInsults;
    final deletedDefaultInsults =
        List<String>.from(state.deletedDefaultInsults);

    if (originalDefaultInsults.contains(event.insult)) {
      deletedDefaultInsults.add(event.insult);
    }

    emit(
      state.copyWith(
        insults: insults,
        deletedDefaultInsults: deletedDefaultInsults,
      ),
    );
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) => state.toJson();
}

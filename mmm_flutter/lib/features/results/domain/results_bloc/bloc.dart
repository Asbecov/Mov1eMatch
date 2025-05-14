import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/main.dart';
import 'package:mmm_client/mmm_client.dart';

part 'state.dart';
part 'event.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  ResultsBloc() : super(const ResultsState.empty()) {
    on<ResultsPromptedEvent>(_onResultsPromptedEvent);
  }

  Future _onResultsPromptedEvent(
    ResultsPromptedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    try {
      final Map<Film, int> results = (await client.session.closeVotingSession(
        sessionId: event.sessionId,
      ))
          .results;

      emit(state._copyWith(results: results));
    } catch (e, st) {
      emit(ResultsErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
    }
  }
}

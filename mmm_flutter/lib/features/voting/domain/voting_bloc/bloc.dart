import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/main.dart';
import 'package:mmm_client/mmm_client.dart';

part "state.dart";
part 'event.dart';

class VotingBloc extends Bloc<VotingEvent, VotingState> {
  VotingBloc() : super(const VotingState.empty()) {
    on<VotingInitEvent>(_onVotingInitEvent);
    on<VotingSubmitedEvent>(_onVotingSubmitedEvent);
    on<VotingRetractedEvent>(_onVotingRetractedEvent);
    on<VotingEndedEvent>(_onVotingEndedEvent);
  }

  Future _onVotingInitEvent(
    VotingInitEvent event,
    Emitter<VotingState> emit,
  ) async {
    try {
      final List<Film> pool = await client.session.connectToVotingSession(
        sessionId: event.sessionId,
      );

      emit(VotingState(
        results: {for (final Film film in pool) film: null},
        sessionId: event.sessionId,
        ended: false,
      ));
    } catch (e, st) {
      emit(VotingErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
    }
  }

  void _onVotingSubmitedEvent(
    VotingSubmitedEvent event,
    Emitter<VotingState> emit,
  ) {
    emit(state._copyWith(
      results: state.results..update(event.film, (oldValue) => event.vote),
    ));
  }

  void _onVotingRetractedEvent(
    VotingRetractedEvent event,
    Emitter<VotingState> emit,
  ) =>
      emit(state._copyWith(
        results: state.results..update(event.film, (oldValue) => null),
      ));

  Future _onVotingEndedEvent(
      VotingEndedEvent event, Emitter<VotingState> emit) async {
    try {
      await client.session.submitVotes(
        sessionId: state.sessionId,
        votes: state.results,
      );

      emit(VotingState.empty()._copyWith(ended: true));
    } catch (e, st) {
      emit(VotingErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
    }
  }
}

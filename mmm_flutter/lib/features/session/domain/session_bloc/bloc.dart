import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/main.dart';
import 'package:mmm_client/mmm_client.dart';

part 'state.dart';
part 'event.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionState.empty()) {
    on<PromptedSessionEvent>(_onPromptedSessionEvent);
    on<CloseSessionEvent>(_onCloseSessionEvent);
  }

  Future _onCloseSessionEvent(
    CloseSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    try {
      await client.session.closeVotingSession(sessionId: state.sessionId!);
    } catch (e, st) {
      emit(SessionErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
    }

    emit(SessionState.empty());
  }

  Future _onPromptedSessionEvent(
    PromptedSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    late final String sessionId;

    try {
      sessionId = await client.session.startVotingSession(pool: event.pool);
    } catch (e, st) {
      emit(SessionErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
      return;
    }

    emit(state._copyWith(sessionId: sessionId));
  }
}

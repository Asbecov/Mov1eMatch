import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmm/main.dart';
import 'package:mmm_client/mmm_client.dart';

part 'state.dart';
part 'event.dart';

class CreateSessionBloc extends Bloc<CreateSessionEvent, CreateSessionState> {
  CreateSessionBloc() : super(const CreateSessionState.empty()) {
    on<PromptedCreateSessionEvent>(_onPromptedCreateSessionEvent);
    on<CloseCreateSessionEvent>(_onCloseCreateSessionEvent);
  }

  Future _onPromptedCreateSessionEvent(
    PromptedCreateSessionEvent event,
    Emitter<CreateSessionState> emit,
  ) async {
    if (state.sessionId == null) {
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
    } else {
      emit(state);
    }
  }

  Future _onCloseCreateSessionEvent(
    CloseCreateSessionEvent event,
    Emitter<CreateSessionState> emit,
  ) async {
    if (state.sessionId != null) {
      try {
        await client.session.closeVotingSession(sessionId: state.sessionId!);
      } catch (e, st) {
        emit(SessionErrorState.fromState(
          state: state,
          error: e,
          stackTrace: st,
        ));
      }

      emit(CreateSessionState.empty());
    } else {
      emit(state);
    }
  }
}

part of 'bloc.dart';

class CreateSessionState extends Equatable {
  const CreateSessionState({required this.sessionId});

  const CreateSessionState.empty() : sessionId = null;

  final String? sessionId;

  CreateSessionState _copyWith({String? sessionId}) =>
      CreateSessionState(sessionId: sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SessionErrorState extends CreateSessionState {
  SessionErrorState.fromState({
    required CreateSessionState state,
    this.error,
    this.stackTrace,
  }) : super(sessionId: state.sessionId);

  final Object? error;
  final StackTrace? stackTrace;
}

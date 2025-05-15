part of 'bloc.dart';

class SessionState extends Equatable {
  const SessionState({required this.sessionId});

  const SessionState.empty() : sessionId = null;

  final String? sessionId;

  SessionState _copyWith({String? sessionId}) =>
      SessionState(sessionId: sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SessionErrorState extends SessionState {
  SessionErrorState.fromState({
    required SessionState state,
    this.error,
    this.stackTrace,
  }) : super(sessionId: state.sessionId);

  final Object? error;
  final StackTrace? stackTrace;
}

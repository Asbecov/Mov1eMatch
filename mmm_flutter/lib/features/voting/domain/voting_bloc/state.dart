part of 'bloc.dart';

class VotingState extends Equatable {
  const VotingState({
    required this.results,
    required this.sessionId,
    required this.ended,
  });

  final String sessionId;
  final bool ended;
  final Map<Film, bool?> results;

  const VotingState.empty()
      : results = const <Film, bool>{},
        sessionId = '',
        ended = false;

  VotingState _copyWith(
          {Map<Film, bool?>? results, String? sessionId, bool? ended}) =>
      VotingState(
        results: results ?? this.results,
        sessionId: sessionId ?? this.sessionId,
        ended: ended ?? this.ended,
      );

  @override
  List<Object?> get props => [...results.entries, sessionId, ended];
}

class VotingErrorState extends VotingState {
  VotingErrorState.fromState({
    required VotingState state,
    this.error,
    this.stackTrace,
  }) : super(
          results: state.results,
          sessionId: state.sessionId,
          ended: state.ended,
        );

  final Object? error;
  final StackTrace? stackTrace;
}

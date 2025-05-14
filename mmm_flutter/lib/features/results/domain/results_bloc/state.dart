part of 'bloc.dart';

class ResultsState extends Equatable {
  const ResultsState({required this.results});

  final Map<Film, int> results;

  const ResultsState.empty() : results = const <Film, int>{};

  ResultsState _copyWith({Map<Film, int>? results}) =>
      ResultsState(results: results ?? this.results);

  @override
  List<Object?> get props => results.entries.toList();
}

class ResultsErrorState extends ResultsState {
  ResultsErrorState.fromState({
    required ResultsState state,
    this.error,
    this.stackTrace,
  }) : super(results: state.results);

  final Object? error;
  final StackTrace? stackTrace;
}

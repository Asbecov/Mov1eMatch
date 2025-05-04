part of 'bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    required this.results,
    required this.currentQuery,
    required int offset,
    required int limit,
    required bool hitEnd,
  })  : _offset = offset,
        _limit = limit,
        _hitEnd = hitEnd;

  const SearchState.empty()
      : results = const <Film>[],
        currentQuery = '',
        _offset = 0,
        _limit = 20,
        _hitEnd = false;

  final List<Film> results;
  final String currentQuery;
  final int _offset;
  final int _limit;
  final bool _hitEnd;

  SearchState _copyWith({
    List<Film>? results,
    String? currentQuery,
    int? offset,
    int? limit,
    bool? hitEnd,
  }) =>
      SearchState(
        results: results ?? this.results,
        currentQuery: currentQuery ?? this.currentQuery,
        offset: offset ?? _offset,
        limit: limit ?? _limit,
        hitEnd: hitEnd ?? _hitEnd,
      );

  @override
  List<Object?> get props => [
        ...results,
        currentQuery,
        _offset,
        _limit,
        _hitEnd,
      ];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import 'package:mmm/main.dart';
import 'package:mmm_client/mmm_client.dart';

part 'state.dart';
part 'event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState.empty()) {
    on<ChangedSearchQueryEvent>(
      _onChangedSearchQueryEvent,
      transformer: _debounce(Duration(milliseconds: 300)),
    );
    on<HitBottomEvent>(
      _handleHitBottomEvent,
      transformer: _debounce(Duration(milliseconds: 300)),
    );
  }

  EventTransformer<E> _debounce<E>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  static const int pageItemCount = 20;

  Future _onChangedSearchQueryEvent(
    ChangedSearchQueryEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state.currentQuery != event.newQuery && event.newQuery != '') {
      late final List<Film> results;

      try {
        results = await client.search.search(
          query: event.newQuery,
          offset: 0,
          limit: pageItemCount,
        );
      } catch (e, st) {
        emit(SearchErrorState.fromState(
          state: state,
          error: e,
          stackTrace: st,
        ));
        return;
      }

      emit(state._copyWith(
        results: results,
        currentQuery: event.newQuery,
        offset: pageItemCount,
        limit: pageItemCount,
        hitEnd: results.length < pageItemCount,
      ));
    }
  }

  Future _handleHitBottomEvent(
    HitBottomEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (!state._hitEnd) {
      late final List<Film> results;

      try {
        results = await client.search.search(
          query: state.currentQuery,
          offset: state._offset,
          limit: pageItemCount,
        );
      } catch (e, st) {
        emit(SearchErrorState.fromState(
          state: state,
          error: e,
          stackTrace: st,
        ));
        return;
      }

      emit(state._copyWith(
        results: [...state.results, ...results],
        offset: state._offset + pageItemCount,
        limit: pageItemCount,
        hitEnd: results.length < pageItemCount,
      ));
    }
  }
}

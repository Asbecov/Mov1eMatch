part of 'bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class ChangedSearchQueryEvent extends SearchEvent {
  const ChangedSearchQueryEvent({required this.newQuery});

  final String newQuery;
}

class HitBottomEvent extends SearchEvent {
  const HitBottomEvent();
}

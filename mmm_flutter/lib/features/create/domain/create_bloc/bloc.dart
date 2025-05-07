import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mmm_client/mmm_client.dart';

part 'event.dart';
part 'state.dart';

extension DuplicateRemovableList<E> on List<E> {
  List<E> removeDuplicates() => LinkedHashSet<E>.from(this).toList();
}

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(const CreateState.empty()) {
    on<AddEntryEvent>(_handleAddEntryEvent);
    on<AddAllEntriesEvent>(_handleAddAllEntriesEvent);
    on<RemoveEntryEvent>(_handleRemoveEntryEvent);
  }

  void _handleAddEntryEvent(
    AddEntryEvent event,
    Emitter<CreateState> emit,
  ) =>
      emit(state.copyWith(
        selection: [...state.selection, event.entry].removeDuplicates(),
      ));

  void _handleAddAllEntriesEvent(
    AddAllEntriesEvent event,
    Emitter<CreateState> emit,
  ) =>
      emit(state.copyWith(
        selection: [...state.selection, ...event.entries].removeDuplicates(),
      ));

  void _handleRemoveEntryEvent(
    RemoveEntryEvent event,
    Emitter<CreateState> emit,
  ) {
    final List<Film> newSelection = List.from(state.selection);
    try {
      newSelection.removeAt(event.index);
    } catch (e, st) {
      emit(CreateErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
      return;
    }

    emit(state.copyWith(selection: newSelection));
  }
}

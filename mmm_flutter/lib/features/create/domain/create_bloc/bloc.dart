import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mmm_client/mmm_client.dart';
import 'package:movie_match/common/models/salute/models.dart';
import 'package:movie_match/main.dart';

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

    _streamSubscription = saluteHandler?.eventStream.listen(
      _eventStreamListener,
    );
  }

  StreamSubscription? _streamSubscription;

  void _eventStreamListener(String data) {
    final BaseCommand command = BaseCommand.fromJson(jsonDecode(data));

    if (command is AddFilmCommand) {
      add(AddEntryEvent(entry: Film(title: command.film, genres: [])));
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();

    return super.close();
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
    try {
      final List<Film> newSelection = List.from(state.selection);
      newSelection.removeAt(event.index);

      emit(state.copyWith(selection: newSelection));
    } catch (e, st) {
      emit(CreateErrorState.fromState(
        state: state,
        error: e,
        stackTrace: st,
      ));
    }
  }
}

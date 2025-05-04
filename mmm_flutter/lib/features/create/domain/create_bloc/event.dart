part of 'bloc.dart';

sealed class CreateEvent {
  const CreateEvent();
}

class AddEntryEvent extends CreateEvent {
  const AddEntryEvent({required this.entry});

  final Film entry;
}

class AddAllEntriesEvent extends CreateEvent {
  const AddAllEntriesEvent({required this.entries});

  final List<Film> entries;
}

class RemoveEntryEvent extends CreateEvent {
  const RemoveEntryEvent({required this.index});

  final int index;
}

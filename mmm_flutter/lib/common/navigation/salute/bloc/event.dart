part of 'bloc.dart';

sealed class SaluteNavigationEvent {
  const SaluteNavigationEvent();
}

class RecievedCommandSaluteNavigationEvent extends SaluteNavigationEvent {
  const RecievedCommandSaluteNavigationEvent({required this.command});

  final BaseCommand command;
}

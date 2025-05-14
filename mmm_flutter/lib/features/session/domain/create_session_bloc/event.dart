part of 'bloc.dart';

sealed class CreateSessionEvent {
  const CreateSessionEvent();
}

class PromptedCreateSessionEvent extends CreateSessionEvent {
  const PromptedCreateSessionEvent({required this.pool});

  final List<Film> pool;
}

class CloseCreateSessionEvent extends CreateSessionEvent {
  const CloseCreateSessionEvent();
}

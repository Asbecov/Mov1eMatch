part of 'bloc.dart';

sealed class SessionEvent {
  const SessionEvent();
}

class PromptedSessionEvent extends SessionEvent {
  const PromptedSessionEvent({required this.pool});

  final List<Film> pool;
}

class CloseSessionEvent extends SessionEvent {
  const CloseSessionEvent();
}

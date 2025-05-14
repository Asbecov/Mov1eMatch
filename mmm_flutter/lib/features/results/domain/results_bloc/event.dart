part of 'bloc.dart';

sealed class ResultsEvent {
  const ResultsEvent();
}

class ResultsPromptedEvent extends ResultsEvent {
  const ResultsPromptedEvent({required this.sessionId});

  final String sessionId;
}

part of 'bloc.dart';

sealed class VotingEvent {
  const VotingEvent();
}

class VotingInitEvent extends VotingEvent {
  const VotingInitEvent({required this.sessionId});

  final String sessionId;
}

class VotingSubmitedEvent extends VotingEvent {
  const VotingSubmitedEvent({required this.film, required this.vote});

  final Film film;
  final bool vote;
}

class VotingRetractedEvent extends VotingEvent {
  const VotingRetractedEvent({required this.film});

  final Film film;
}

class VotingEndedEvent extends VotingEvent {
  const VotingEndedEvent();
}

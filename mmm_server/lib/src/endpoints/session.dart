import 'dart:async';

import 'package:mmm_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class SessionEndpoint extends Endpoint {
  SessionEndpoint() {
    _startSessionCleanupTimer();
  }

  // Maps each sessions id to its voting pool and voting results
  Map<String, (List<Film>, Map<Film, int>, DateTime)> sessions = {};

  static const Duration sessionTimeout = Duration(minutes: 10);
  // ignore: unused_field
  Timer? _sessionCleanupTimer;

  void _startSessionCleanupTimer() => _sessionCleanupTimer = Timer.periodic(
        Duration(minutes: 5),
        _checkInactiveSessions,
      );

  void _checkInactiveSessions(Timer timer) {
    final DateTime now = DateTime.now();
    final List<String> inactiveSessions = sessions.entries
        .where((entry) => now.difference(entry.value.$3) > sessionTimeout)
        .map((entry) => entry.key)
        .toList();

    for (final sessionId in inactiveSessions) {
      _closeVotingSessionById(sessionId);
    }
  }

  void _closeVotingSessionById(String sessionId) {
    if (!sessions.containsKey(sessionId)) return;

    sessions.remove(sessionId);
  }

  Future<String> startVotingSession(
    Session session, {
    required List<Film> pool,
  }) async {
    final String sessionId = const Uuid().v4();

    sessions[sessionId] = (
      pool,
      {for (final Film value in pool) value: 0},
      DateTime.now(),
    );
    return sessionId;
  }

  Future<VotingResults> closeVotingSession(
    Session session, {
    required String sessionId,
  }) async {
    if (!sessions.containsKey(sessionId)) {
      session.log(
        'Session with session id: $sessionId doesn`t exist to close it',
        level: LogLevel.info,
      );
      throw NotFoundException(
        message:
            'Session with session id: $sessionId doesn`t exist to close it',
      );
    }

    final VotingResults result = VotingResults(
      results: sessions[sessionId]!.$2,
    );

    sessions.remove(sessionId);

    return result;
  }

  Future<void> submitVotes(
    Session session, {
    required String sessionId,
    required Map<Film, bool?> votes,
  }) async {
    if (!sessions.containsKey(sessionId)) {
      session.log(
        'Session with session id: $sessionId doesn`t exist to submit votes',
        level: LogLevel.info,
      );
      throw NotFoundException(
        message:
            'Session with session id: $sessionId doesn`t exist to submit votes',
      );
    }

    Map<Film, int> result = {};

    for (final MapEntry<Film, bool?> vote in votes.entries) {
      final int curResult = sessions[sessionId]!
          .$2
          .entries
          .firstWhere((value) => (value.key.title == vote.key.title))
          .value;

      result[vote.key] = switch (vote.value) {
        true => curResult + 1,
        false => curResult - 1,
        null => curResult,
      };
    }

    // Update last activity time
    sessions[sessionId] = (
      sessions[sessionId]!.$1,
      result,
      DateTime.now(),
    );
  }

  Future<List<Film>> connectToVotingSession(
    Session session, {
    required String sessionId,
  }) async {
    if (!sessions.containsKey(sessionId)) {
      session.log(
        'Session with session id: $sessionId doesn`t exist to connect',
        level: LogLevel.info,
      );
      throw NotFoundException(
        message: 'Session with session id: $sessionId doesn`t exist to connect',
      );
    }

    final List<Film> sessionPool = sessions[sessionId]!.$1;
    // Update last activity time
    sessions[sessionId] = (
      sessions[sessionId]!.$1,
      sessions[sessionId]!.$2,
      DateTime.now(),
    );

    return sessionPool;
  }
}

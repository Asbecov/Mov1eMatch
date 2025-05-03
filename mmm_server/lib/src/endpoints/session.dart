import 'package:mmm_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class SessionEndpoint extends Endpoint {
  // Maps each sessions id to its voting pool and voting results
  Map<String, (List<Film>, Map<Film, int>)> sessions = {};

  Future<String> startVotingSession(
    Session session, {
    required List<Film> pool,
  }) async {
    final String sessionId = const Uuid().v4();

    sessions[sessionId] = (pool, {for (final Film value in pool) value: 0});
    return sessionId;
  }

  Future<VotingResults?> closeVotingSession(
    Session session, {
    required String sessionId,
  }) async {
    if (!sessions.containsKey(sessionId)) {
      session.log(
        'Session with session id: $sessionId doesn`t exist to delete it',
        level: LogLevel.info,
      );
      return null;
    }

    final VotingResults result = VotingResults(
      results: sessions[sessionId]!.$2,
    );

    sessions.remove(sessionId);
    return result;
  }

  Future<bool> submitVotes(
    Session session, {
    required String sessionId,
    required Map<String, bool> votes,
  }) async {
    if (!sessions.containsKey(sessionId)) {
      session.log(
        'Session with session id: $sessionId doesn`t exist to submit votes',
        level: LogLevel.info,
      );
      return false;
    }

    Map<Film, int> curSessionResults = sessions[sessionId]!.$2;

    for (MapEntry<String, bool> entry in votes.entries) {
      final Film film = sessions[sessionId]!
          .$1
          .firstWhere((Film film) => film.title == entry.key);

      curSessionResults.update(
        film,
        (int value) => entry.value ? ++value : value,
      );
    }
    return true;
  }

  Stream connectToVotingSession(
    Session session, {
    required String sessionId,
  }) async* {}
}

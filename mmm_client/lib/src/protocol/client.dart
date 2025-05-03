/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:mmm_client/src/protocol/film.dart' as _i3;
import 'package:mmm_client/src/protocol/voting_results.dart' as _i4;
import 'protocol.dart' as _i5;

/// {@category Endpoint}
class EndpointSearch extends _i1.EndpointRef {
  EndpointSearch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'search';

  _i2.Future<List<_i3.Film>> search({
    required String query,
    required int offset,
    required int limit,
  }) =>
      caller.callServerEndpoint<List<_i3.Film>>(
        'search',
        'search',
        {
          'query': query,
          'offset': offset,
          'limit': limit,
        },
      );
}

/// {@category Endpoint}
class EndpointSession extends _i1.EndpointRef {
  EndpointSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'session';

  _i2.Future<String> startVotingSession({required List<_i3.Film> pool}) =>
      caller.callServerEndpoint<String>(
        'session',
        'startVotingSession',
        {'pool': pool},
      );

  _i2.Future<_i4.VotingResults?> closeVotingSession(
          {required String sessionId}) =>
      caller.callServerEndpoint<_i4.VotingResults?>(
        'session',
        'closeVotingSession',
        {'sessionId': sessionId},
      );

  _i2.Future<bool> submitVotes({
    required String sessionId,
    required Map<String, bool> votes,
  }) =>
      caller.callServerEndpoint<bool>(
        'session',
        'submitVotes',
        {
          'sessionId': sessionId,
          'votes': votes,
        },
      );

  _i2.Stream<dynamic> connectToVotingSession({required String sessionId}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<dynamic>, dynamic>(
        'session',
        'connectToVotingSession',
        {'sessionId': sessionId},
        {},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i5.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    search = EndpointSearch(this);
    session = EndpointSession(this);
  }

  late final EndpointSearch search;

  late final EndpointSession session;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'search': search,
        'session': session,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}

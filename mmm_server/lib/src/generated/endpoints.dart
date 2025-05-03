/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/search.dart' as _i2;
import '../endpoints/session.dart' as _i3;
import 'package:mmm_server/src/generated/film.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'search': _i2.SearchEndpoint()
        ..initialize(
          server,
          'search',
          null,
        ),
      'session': _i3.SessionEndpoint()
        ..initialize(
          server,
          'session',
          null,
        ),
    };
    connectors['search'] = _i1.EndpointConnector(
      name: 'search',
      endpoint: endpoints['search']!,
      methodConnectors: {
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['search'] as _i2.SearchEndpoint).search(
            session,
            query: params['query'],
            offset: params['offset'],
            limit: params['limit'],
          ),
        )
      },
    );
    connectors['session'] = _i1.EndpointConnector(
      name: 'session',
      endpoint: endpoints['session']!,
      methodConnectors: {
        'startVotingSession': _i1.MethodConnector(
          name: 'startVotingSession',
          params: {
            'pool': _i1.ParameterDescription(
              name: 'pool',
              type: _i1.getType<List<_i4.Film>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['session'] as _i3.SessionEndpoint).startVotingSession(
            session,
            pool: params['pool'],
          ),
        ),
        'closeVotingSession': _i1.MethodConnector(
          name: 'closeVotingSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['session'] as _i3.SessionEndpoint).closeVotingSession(
            session,
            sessionId: params['sessionId'],
          ),
        ),
        'submitVotes': _i1.MethodConnector(
          name: 'submitVotes',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'votes': _i1.ParameterDescription(
              name: 'votes',
              type: _i1.getType<Map<String, bool>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['session'] as _i3.SessionEndpoint).submitVotes(
            session,
            sessionId: params['sessionId'],
            votes: params['votes'],
          ),
        ),
        'connectToVotingSession': _i1.MethodStreamConnector(
          name: 'connectToVotingSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['session'] as _i3.SessionEndpoint)
                  .connectToVotingSession(
            session,
            sessionId: params['sessionId'],
          ),
        ),
      },
    );
  }
}

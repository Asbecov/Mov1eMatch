/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:mmm_server/src/generated/film.dart' as _i4;
import 'package:mmm_server/src/generated/voting_results.dart' as _i5;
import 'package:mmm_server/src/generated/protocol.dart';
import 'package:mmm_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 30)`.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
@_i1.isTestGroup
void withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  bool? enableSessionLogging,
  _i2.ExperimentalFeatures? experimentalFeatures,
  String? runMode,
  _i2.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
}) {
  _i1.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _i1.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: false,
      isDatabaseEnabled: false,
      serverpodLoggingMode: serverpodLoggingMode,
      experimentalFeatures: experimentalFeatures,
    ),
    maybeRollbackDatabase: _i1.RollbackDatabase.disabled,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
  )(testClosure);
}

class TestEndpoints {
  late final _SearchEndpoint search;

  late final _SessionEndpoint session;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  void initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    search = _SearchEndpoint(endpoints, serializationManager);
    session = _SessionEndpoint(endpoints, serializationManager);
  }
}

class _SearchEndpoint {
  _SearchEndpoint(this._endpointDispatch, this._serializationManager);

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i4.Film>> search(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
    required int offset,
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'search', method: 'search');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          SessionCallback: (_) => _localUniqueSession,
          endpointPath: 'search',
          methodName: 'search',
          parameters: _i1.testObjectToJson({
            'query': query,
            'offset': offset,
            'limit': limit,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i4.Film>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SessionEndpoint {
  _SessionEndpoint(this._endpointDispatch, this._serializationManager);

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> startVotingSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required List<_i4.Film> pool,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'session', method: 'startVotingSession');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          SessionCallback: (_) => _localUniqueSession,
          endpointPath: 'session',
          methodName: 'startVotingSession',
          parameters: _i1.testObjectToJson({'pool': pool}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i5.VotingResults> closeVotingSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'session', method: 'closeVotingSession');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          SessionCallback: (_) => _localUniqueSession,
          endpointPath: 'session',
          methodName: 'closeVotingSession',
          parameters: _i1.testObjectToJson({'sessionId': sessionId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i5.VotingResults>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> submitVotes(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionId,
    required Map<_i4.Film, bool?> votes,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'session', method: 'submitVotes');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          SessionCallback: (_) => _localUniqueSession,
          endpointPath: 'session',
          methodName: 'submitVotes',
          parameters: _i1.testObjectToJson({
            'sessionId': sessionId,
            'votes': votes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i4.Film>> connectToVotingSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder
              as _i1.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'session', method: 'connectToVotingSession');
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          SessionCallback: (_) => _localUniqueSession,
          endpointPath: 'session',
          methodName: 'connectToVotingSession',
          parameters: _i1.testObjectToJson({'sessionId': sessionId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i4.Film>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

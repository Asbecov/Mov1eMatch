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
import 'package:serverpod/protocol.dart' as _i2;
import 'film.dart' as _i3;
import 'not_found_exception.dart' as _i4;
import 'voting_results.dart' as _i5;
import 'package:mmm_server/src/generated/film.dart' as _i6;
export 'film.dart';
export 'not_found_exception.dart';
export 'voting_results.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i2.Protocol.targetTableDefinitions
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.Film) {
      return _i3.Film.fromJson(data) as T;
    }
    if (t == _i4.NotFoundException) {
      return _i4.NotFoundException.fromJson(data) as T;
    }
    if (t == _i5.VotingResults) {
      return _i5.VotingResults.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.Film?>()) {
      return (data != null ? _i3.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.NotFoundException?>()) {
      return (data != null ? _i4.NotFoundException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.VotingResults?>()) {
      return (data != null ? _i5.VotingResults.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<_i3.Film, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<_i3.Film>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == List<_i6.Film>) {
      return (data as List).map((e) => deserialize<_i6.Film>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.Film) {
      return 'Film';
    }
    if (data is _i4.NotFoundException) {
      return 'NotFoundException';
    }
    if (data is _i5.VotingResults) {
      return 'VotingResults';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i3.Film>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_i4.NotFoundException>(data['data']);
    }
    if (dataClassName == 'VotingResults') {
      return deserialize<_i5.VotingResults>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'mmm';
}

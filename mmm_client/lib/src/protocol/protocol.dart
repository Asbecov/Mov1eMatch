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
import 'film.dart' as _i2;
import 'not_found_exception.dart' as _i3;
import 'voting_results.dart' as _i4;
import 'package:mmm_client/src/protocol/film.dart' as _i5;
export 'film.dart';
export 'not_found_exception.dart';
export 'voting_results.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Film) {
      return _i2.Film.fromJson(data) as T;
    }
    if (t == _i3.NotFoundException) {
      return _i3.NotFoundException.fromJson(data) as T;
    }
    if (t == _i4.VotingResults) {
      return _i4.VotingResults.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Film?>()) {
      return (data != null ? _i2.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.NotFoundException?>()) {
      return (data != null ? _i3.NotFoundException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.VotingResults?>()) {
      return (data != null ? _i4.VotingResults.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<_i2.Film, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<_i2.Film>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == List<_i5.Film>) {
      return (data as List).map((e) => deserialize<_i5.Film>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Film) {
      return 'Film';
    }
    if (data is _i3.NotFoundException) {
      return 'NotFoundException';
    }
    if (data is _i4.VotingResults) {
      return 'VotingResults';
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
      return deserialize<_i2.Film>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_i3.NotFoundException>(data['data']);
    }
    if (dataClassName == 'VotingResults') {
      return deserialize<_i4.VotingResults>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}

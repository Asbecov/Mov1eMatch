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

abstract class VotingResults implements _i1.SerializableModel {
  VotingResults._({required this.results});

  factory VotingResults({required Map<_i2.Film, int> results}) =
      _VotingResultsImpl;

  factory VotingResults.fromJson(Map<String, dynamic> jsonSerialization) {
    return VotingResults(
        results: (jsonSerialization['results'] as List)
            .fold<Map<_i2.Film, int>>(
                {},
                (t, e) => {
                      ...t,
                      _i2.Film.fromJson((e['k'] as Map<String, dynamic>)):
                          e['v'] as int
                    }));
  }

  Map<_i2.Film, int> results;

  /// Returns a shallow copy of this [VotingResults]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VotingResults copyWith({Map<_i2.Film, int>? results});
  @override
  Map<String, dynamic> toJson() {
    return {'results': results.toJson(keyToJson: (k) => k.toJson())};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _VotingResultsImpl extends VotingResults {
  _VotingResultsImpl({required Map<_i2.Film, int> results})
      : super._(results: results);

  /// Returns a shallow copy of this [VotingResults]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VotingResults copyWith({Map<_i2.Film, int>? results}) {
    return VotingResults(
        results: results ??
            this.results.map((
                  key0,
                  value0,
                ) =>
                    MapEntry(
                      key0.copyWith(),
                      value0,
                    )));
  }
}

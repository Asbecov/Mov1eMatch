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

abstract class Film implements _i1.SerializableModel {
  Film._({
    this.art,
    required this.title,
    this.description,
    required this.genres,
  });

  factory Film({
    String? art,
    required String title,
    String? description,
    required List<String> genres,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> jsonSerialization) {
    return Film(
      art: jsonSerialization['art'] as String?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      genres: (jsonSerialization['genres'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  String? art;

  String title;

  String? description;

  List<String> genres;

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Film copyWith({
    String? art,
    String? title,
    String? description,
    List<String>? genres,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (art != null) 'art': art,
      'title': title,
      if (description != null) 'description': description,
      'genres': genres.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FilmImpl extends Film {
  _FilmImpl({
    String? art,
    required String title,
    String? description,
    required List<String> genres,
  }) : super._(
          art: art,
          title: title,
          description: description,
          genres: genres,
        );

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Film copyWith({
    Object? art = _Undefined,
    String? title,
    Object? description = _Undefined,
    List<String>? genres,
  }) {
    return Film(
      art: art is String? ? art : this.art,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      genres: genres ?? this.genres.map((e0) => e0).toList(),
    );
  }
}

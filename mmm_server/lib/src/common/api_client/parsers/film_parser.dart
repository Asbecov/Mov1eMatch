import 'package:mmm_server/src/generated/protocol.dart';

List<Film> filmParser(List<dynamic> data, Map<int, String> genres) {
  final result = <Film>[];

  for (final raw in data) {
    final Map<String, dynamic> film = raw as Map<String, dynamic>;

    final List<dynamic> posters =
        film["poster_originals"] as List<dynamic>? ?? [];
    final Map<String, dynamic> verticalPoster = posters.firstWhere(
      (poster) => poster["type"] == "Poster",
      orElse: () => {"path": null},
    );

    final genreIds = film["genres"] as List<dynamic>? ?? [];

    result.add(Film(
      title: film["title"],
      description: (film["description"] as String).replaceAll(
        RegExp(r'(<\/?p>)|(\r\n|\r|\n)'),
        '',
      ),
      art: verticalPoster["path"],
      genres: genreIds
          .map((id) => genres[id] ?? 'неизвестный')
          .cast<String>()
          .toList(),
    ));
  }

  return result;
}

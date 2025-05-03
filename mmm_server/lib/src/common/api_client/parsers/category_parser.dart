Map<int, String> categoryParser(Map<String, dynamic> data) {
  final result = <int, String>{};

  final categories = data["result"] as List<dynamic>?;

  if (categories == null) return result;

  for (final category in categories) {
    final genresList = category["genres"] as List<dynamic>?;

    if (genresList == null) continue;

    for (final genre in genresList) {
      result[genre["id"]] = genre["title"];
    }
  }

  return result;
}

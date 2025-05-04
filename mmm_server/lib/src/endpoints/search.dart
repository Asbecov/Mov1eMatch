import 'package:serverpod/serverpod.dart';

import 'package:dio/dio.dart';

import 'package:mmm_server/src/generated/protocol.dart';

import 'package:mmm_server/src/common/api_client/api_client.dart';

import 'package:mmm_server/src/common/api_client/parsers/category_parser.dart';
import 'package:mmm_server/src/common/api_client/parsers/film_parser.dart';

import 'package:mmm_server/src/common/constants/ivi_api_constants.dart';

class SearchEndpoint extends Endpoint {
  static Map<int, String> genres = <int, String>{};

  Future<List<Film>> search(
    Session session, {
    required String query,
    int offset = 0,
    int limit = 20,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "query": query,
      "from": offset,
      "to": offset + limit - 1,
    };

    try {
      final Response response = await apiClient.get<List<dynamic>>(
        searchPath,
        queryParametrs: params,
      );

      if (response.statusCode == 200) {
        return filmParser(response.data ?? [], genres);
      } else {
        session.log(
          "Coulnd't fetch search results for querry: $query, IVI API code response code being: ${response.statusCode}",
          level: LogLevel.error,
        );
        return [];
      }
    } catch (e, st) {
      session.log(
        "Couldn't search results for query: $query",
        exception: e,
        stackTrace: st,
        level: LogLevel.error,
      );
      return [];
    }
  }

  @ignoreEndpoint
  Future<void> fetchGenres(Session session) async {
    late final Response<Map<String, dynamic>> response;

    try {
      response = await apiClient.get<Map<String, dynamic>>(categoriesPath);

      if (response.statusCode == 200) {
        genres = categoryParser(response.data ?? {});
      } else {
        session.log(
          """Failed to fetch categories from the IVI API, categories might not work. 
          IVI API response code being: ${response.statusCode}
          """,
          level: LogLevel.error,
        );
      }
    } catch (e, st) {
      session.log(
        """Failed to fetch categories from the IVI API, categories might not work. 
          The error being: 
          $e
        """,
        exception: e,
        stackTrace: st,
      );
      return;
    }
  }
}

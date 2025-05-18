import 'package:flutter/material.dart';

import 'package:movie_match/app/movie_match.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';

late final Client client;
void main() {
  client = Client(serverUrl);

  runApp(const movie_match());
}

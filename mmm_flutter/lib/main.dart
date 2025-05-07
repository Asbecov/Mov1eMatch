import 'package:flutter/material.dart';

import 'package:mmm/app/movie_match.dart';
import 'package:mmm_client/mmm_client.dart';

late final Client client;
void main() {
  final String serverUrl = String.fromEnvironment(
    "MASTER-URL",
    defaultValue: 'http://localhost:8080/',
  );

  client = Client(serverUrl);

  runApp(const MovieMatch());
}

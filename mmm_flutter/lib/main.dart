import 'package:flutter/material.dart';

import 'package:mmm/app/movie_match.dart';
import 'package:mmm_client/mmm_client.dart';

late final Client client;
void main() async {
  client = Client('http://localhost:8080/');

  runApp(const MovieMatch());
}

import 'package:flutter/material.dart';

import 'package:mmm/app/movie_match.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';

late final Client client;
void main() {
  client = Client(serverUrl);

  runApp(const MovieMatch());
}

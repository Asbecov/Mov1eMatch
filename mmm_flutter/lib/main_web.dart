import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:movie_match/main.dart';

import 'package:movie_match/app/movie_match.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';

void main() {
  usePathUrlStrategy();
  client = Client(serverUrl);

  runApp(const MovieMatch());
}

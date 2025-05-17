import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:mmm/main.dart';

import 'package:mmm/app/movie_match.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';

void main() {
  usePathUrlStrategy();
  client = Client(serverUrl);

  runApp(const MovieMatch());
}

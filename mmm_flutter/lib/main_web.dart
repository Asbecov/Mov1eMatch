import 'package:flutter/material.dart';

import 'package:mmm/app/movie_match.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

late final Client client;
void main() {
  usePathUrlStrategy();
  client = Client(serverUrl);

  runApp(const MovieMatch());
}

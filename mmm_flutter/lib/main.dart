import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mmm/app/movie_match.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';

import 'package:mmm/web_only_stub.dart' if (kIsWeb) 'package:mmm/web_only.dart';

late final Client client;
void main() {
  if (kIsWeb) importPathUrlStrategy();
  client = Client(serverUrl);

  runApp(const MovieMatch());
}

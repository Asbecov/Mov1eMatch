import 'dart:io';

import 'package:flutter/material.dart';

import 'package:movie_match/app/movie_match.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:mmm_client/mmm_client.dart';
import 'package:salute_handler/salute_handler.dart';

late final Client client;
SaluteHandler? saluteHandler;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  client = Client(serverUrl);
  if (Platform.isAndroid) saluteHandler = SaluteHandler();

  runApp(const MovieMatch());
}

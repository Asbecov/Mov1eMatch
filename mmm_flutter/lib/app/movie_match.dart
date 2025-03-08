import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/navigation/router.dart';
import 'package:mmm/common/theme/dark_theme.dart';

class MovieMatch extends StatelessWidget {
  const MovieMatch({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: title,
        routerConfig: route,
        theme: theme,
      );
}

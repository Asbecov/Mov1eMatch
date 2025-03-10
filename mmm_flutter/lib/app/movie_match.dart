import 'package:flutter/material.dart';
import 'package:mmm/common/constants/app_constants.dart';
import 'package:mmm/common/navigation/router.dart';
import 'package:mmm/common/theme/theme.dart';

class MovieMatch extends StatelessWidget {
  const MovieMatch({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: title,
        routerConfig: route,
        themeMode: ThemeMode.dark,
        theme: MaterialTheme().light(),
        darkTheme: MaterialTheme().dark(),
        highContrastDarkTheme: MaterialTheme().lightHighContrast(),
        highContrastTheme: MaterialTheme().darkHighContrast(),
      );
}

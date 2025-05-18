import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_match/common/constants/app_constants.dart';
import 'package:movie_match/common/navigation/router.dart';
import 'package:movie_match/common/theme/theme.dart';
import 'package:movie_match/features/create/domain/create_bloc/bloc.dart';
import 'package:movie_match/features/create/domain/search_bloc/bloc.dart';

class movie_match extends StatelessWidget {
  const movie_match({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<CreateBloc>(
            create: (context) => CreateBloc(),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(),
          ),
        ],
        child: MaterialApp.router(
          title: title,
          routerConfig: route,
          themeMode: ThemeMode.dark,
          theme: MaterialTheme().light(),
          darkTheme: MaterialTheme().dark(),
          highContrastDarkTheme: MaterialTheme().lightHighContrast(),
          highContrastTheme: MaterialTheme().darkHighContrast(),
        ),
      );
}

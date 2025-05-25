import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_match/common/constants/app_constants.dart';
import 'package:movie_match/common/models/salute/models.dart';
import 'package:movie_match/common/navigation/router.dart';
import 'package:movie_match/common/theme/theme.dart';
import 'package:movie_match/features/create/domain/create_bloc/bloc.dart';
import 'package:movie_match/features/create/domain/search_bloc/bloc.dart';
import 'package:movie_match/main.dart';

class MovieMatch extends StatelessWidget {
  const MovieMatch({super.key});

  @override
  Widget build(BuildContext context) => SaluteNavigation(
        child: MultiBlocProvider(
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
            routerConfig: router,
            themeMode: ThemeMode.dark,
            theme: MaterialTheme().light(),
            darkTheme: MaterialTheme().dark(),
            highContrastDarkTheme: MaterialTheme().lightHighContrast(),
            highContrastTheme: MaterialTheme().darkHighContrast(),
          ),
        ),
      );
}

class SaluteNavigation extends StatefulWidget {
  const SaluteNavigation({super.key, required this.child});

  final Widget child;

  @override
  State<SaluteNavigation> createState() => _NavigationState();
}

class _NavigationState extends State<SaluteNavigation> {
  late final StreamSubscription<String>? _saluteHandlerSubscription;

  @override
  void initState() {
    super.initState();

    _saluteHandlerSubscription =
        saluteHandler?.navigationEventStream.listen(_saluteHandlerListener);
  }

  void _saluteHandlerListener(String data) {
    final NavigationCommand command = NavigationCommand.fromJson(
      jsonDecode(data),
    );
    final FocusManager manager = FocusManager.instance;

    manager.primaryFocus?.focusInDirection(switch (command.command) {
      NavCommand.down => TraversalDirection.down,
      NavCommand.left => TraversalDirection.left,
      NavCommand.up => TraversalDirection.up,
      NavCommand.right => TraversalDirection.right,
    });
  }

  @override
  void dispose() {
    _saluteHandlerSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

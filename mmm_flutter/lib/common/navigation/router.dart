import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/features/create/views/create_view.dart';
import 'package:mmm/features/session/domain/session_bloc/bloc.dart';
import 'package:mmm/features/session/views/session_view.dart';

final GoRouter route = GoRouter(
  initialLocation: createRoute,
  onException: (context, state, router) =>
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Что-то пошло не так"),
          if (kDebugMode) Text(state.error?.message ?? ""),
        ],
      ),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ),
    ),
  ),
  routes: <RouteBase>[
    GoRoute(
      path: createRoute,
      name: createName,
      builder: (context, state) => CreateView(),
    ),
    GoRoute(
      path: createSessionRoute,
      name: createSessionName,
      builder: (context, state) => BlocProvider<SessionBloc>(
        create: (context) => SessionBloc(),
        child: const SessionView(),
      ),
      routes: <GoRoute>[
        GoRoute(
          path: resultsRoute,
          name: resultsName,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
    GoRoute(
      path: sessionRoute,
      builder: (context, state) => const Placeholder(),
    ),
  ],
);

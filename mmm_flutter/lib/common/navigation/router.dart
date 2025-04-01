import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/features/create/views/create_view.dart';
import 'package:mmm/features/home/views/home_view.dart';

final GoRouter route = GoRouter(
  initialLocation: createRoute,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeRoute(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: createRoute,
            name: createName,
            builder: (context, state) => const CreateView(),
          ),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: collectionsRoute,
            name: collectionsName,
            builder: (context, state) => const Placeholder(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: vottingRoute,
      builder: (context, state) => const Placeholder(),
      routes: <GoRoute>[
        GoRoute(
          path: resultsRoute,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ),
  ],
);

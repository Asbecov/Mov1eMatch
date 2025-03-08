import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/features/create/views/create_view.dart';
import 'package:mmm/features/home/views/home_view.dart';

final GoRouter route = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: mainRoute,
      builder: (context, state) => const HomeView(),
      routes: <GoRoute>[
        GoRoute(
          path: createRoute,
          builder: (context, state) => const CreateView(),
        ),
        GoRoute(
          path: collectionsRoute,
          builder: (context, state) => const Placeholder(),
        ),
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
        ]),
  ],
);

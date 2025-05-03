import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mmm/common/constants/routing_constants.dart';
import 'package:mmm/features/create/views/create_view.dart';

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
      builder: (context, state) => const CreateView(),
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
